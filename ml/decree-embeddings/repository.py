import os
from time import time

import psycopg2
import psycopg2.extras
from logger import logger
from tenacity import retry, stop_after_attempt, wait_exponential

database_name = os.getenv("OPENCOURTS_DATABASE_NAME")

params = {
    "dbname": database_name,
    "user": os.getenv("OPENCOURTS_DATABASE_USER"),
    "password": os.getenv("OPENCOURTS_DATABASE_PASSWORD"),
    "host": "localhost",
    "port": 5432,
}


def connection(f):
    def wrapper(repository, *args, **kwargs):
        if not repository.connected():
            logger.warning(
                f"Connection to [{database_name}] database is closed, reconnecting ..."
            )

            repository.connect()

        try:
            return f(repository, *args, **kwargs)
        except psycopg2.Error:
            repository.disconnect()
            raise

    return wrapper


class Repository:
    def __init__(self):
        self._connection = None

        self.connect()

    def connect(self):
        if not self.connected():
            self._connection = psycopg2.connect(**params)

            logger.info(f"Connected to [{database_name}] database")

    def connected(self):
        return self._connection and self._connection.closed == 0

    def disconnect(self):
        if self.connected():
            self._connection.close()
            self._connection = None

    @retry
    @connection
    def decrees_vocabulary(self):
        cur = self._connection.cursor()

        cur.execute(
            """
            SELECT value FROM court_types
            UNION
            SELECT value FROM decree_forms
            UNION
            SELECT value FROM decree_natures
            UNION
            SELECT value FROM legislation_areas
            UNION
            SELECT value FROM legislation_subareas
            UNION
            SELECT value FROM legislations
        """
        )

        rows = cur.fetchall()

        return [row[0] for row in rows]

    @retry
    @connection
    def decrees(
        self, include_text=True, batch_size=10_000, without_embedding_only=False
    ):
        cur = self._connection.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
        last_id = 0

        text_query = (
            """
            ,ARRAY_TO_STRING(
                (
                SELECT ARRAY_AGG(decree_pages.text ORDER BY decree_pages.number ASC) FROM decree_pages
                WHERE decree_pages.decree_id = decrees.id
                GROUP BY decree_pages.decree_id
                ),
                ''
            ) AS text
            """
            if include_text
            else ""
        )

        without_embedding_only_query = (
            "AND embedding IS NULL" if without_embedding_only else ""
        )

        while True:
            start_time = time()

            cur.execute(
                f"""
                SELECT
                    decrees.id AS id,
                    (ARRAY_AGG(decree_forms.value))[1] AS form,
                    (ARRAY_AGG(courts.name))[1] AS court,
                    (ARRAY_AGG(court_types.value))[1] AS court_type,
                    EXTRACT(YEAR FROM date) :: INTEGER AS year,
                    ARRAY_AGG(DISTINCT decree_natures.value) FILTER (WHERE decree_natures.value IS NOT NULL) AS natures,
                    ARRAY_AGG(DISTINCT legislation_areas.value) FILTER (WHERE legislation_areas.value IS NOT NULL) AS legislation_areas,
                    ARRAY_AGG(DISTINCT legislation_subareas.value) FILTER (WHERE legislation_subareas.value IS NOT NULL) AS legislation_subareas,
                    ARRAY_AGG(DISTINCT legislations.value) FILTER (WHERE legislations.value IS NOT NULL) AS legislations
                    {text_query}
                FROM decrees

                LEFT OUTER JOIN decree_forms ON decree_forms.id = decrees.decree_form_id

                LEFT OUTER JOIN decree_naturalizations ON decree_naturalizations.decree_id = decrees.id
                LEFT OUTER JOIN decree_natures ON decree_natures.id = decree_naturalizations.decree_nature_id

                LEFT OUTER JOIN legislation_area_usages ON legislation_area_usages.decree_id = decrees.id
                LEFT OUTER JOIN legislation_areas ON legislation_areas.id = legislation_area_usages.legislation_area_id

                LEFT OUTER JOIN legislation_subarea_usages ON legislation_subarea_usages.decree_id = decrees.id
                LEFT OUTER JOIN legislation_subareas ON legislation_subareas.id = legislation_subarea_usages.legislation_subarea_id

                LEFT OUTER JOIN legislation_usages ON legislation_usages.decree_id = decrees.id
                LEFT OUTER JOIN legislations ON legislations.id = legislation_usages.legislation_id

                LEFT OUTER JOIN courts ON courts.id = decrees.court_id
                LEFT OUTER JOIN court_types ON court_types.id = courts.court_type_id

                WHERE
                    decrees.id > %s
                    {without_embedding_only_query}
                
                GROUP BY decrees.id
                ORDER BY decrees.id ASC
                LIMIT %s
                """,
                (last_id, batch_size),
            )

            rows = cur.fetchall()

            time_in_ms = (time() - start_time) * 1000

            if not rows:
                break

            logger.info(f"Fetched [{len(rows)}] decrees in [{time_in_ms:.2f}ms]")

            yield rows

            last_id = rows[-1]["id"]

        cur.close()

    @retry
    @connection
    def store_decrees_embeddings(self, decrees):
        start_time = time()
        cur = self._connection.cursor()

        cur.executemany(
            "UPDATE decrees SET embedding = %s WHERE id = %s",
            [
                (f"[{','.join(map(str, decree['embedding']))}]", decree["id"])
                for decree in decrees
            ],
        )

        self._connection.commit()

        time_in_ms = (time() - start_time) * 1000
        logger.info(f"Stored [{len(decrees)}] embeddings in [{time_in_ms:.2f}ms]")

    @retry
    @connection
    def remove_embeddings_index(self):
        cur = self._connection.cursor()

        cur.execute("DROP INDEX IF EXISTS decrees_embedding_idx")

        self._connection.commit()

        cur.close()

    @retry
    @connection
    def create_embeddings_index(self):
        cur = self._connection.cursor()

        cur.execute(
            "CREATE INDEX decrees_embedding_idx ON decrees USING hnsw (embedding vector_cosine_ops) WITH (m = 20, ef_construction = 64);"
        )

        self._connection.commit()

        cur.close()


repository = Repository()
