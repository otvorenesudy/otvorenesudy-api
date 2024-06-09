import os
from time import time

import psycopg2
import psycopg2.extras
from logger import logger

params = {
    "dbname": os.getenv("OPENCOURTS_DATABASE_NAME"),
    "user": os.getenv("OPENCOURTS_DATABASE_USER"),
    "password": os.getenv("OPENCOURTS_DATABASE_PASSWORD"),
    "host": "localhost",
    "port": 5432,
}
db = psycopg2.connect(**params)


def decrees_vocabulary():
    cur = db.cursor()

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

    return cur.fetchall()


def decrees(include_text=True, batch_size=1000):
    cur = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
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

              WHERE decrees.id > %s
              
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


def store_decrees_embeddings(decrees):
    start_time = time()
    cur = db.cursor()

    cur.executemany(
        "UPDATE decrees SET embedding = %s WHERE id = %s",
        [(f"[{",".join(map(str, decree['embedding']))}]", decree['id']) for decree in decrees],
    )

    db.commit()

    time_in_ms = (time() - start_time) * 1000
    logger.info(f"Stored [{len(decrees)}] embeddings in [{time_in_ms:.2f}ms]")


def disconnect():
    db.close()
