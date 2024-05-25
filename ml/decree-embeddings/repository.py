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


def decrees(batch_size=1000):
    cur = db.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    last_id = 0

    while True:
        start_time = time()

        cur.execute(
            f"""
              SELECT
                decrees.id AS id,
                decree_forms.value AS form,
                courts.name AS court,
                court_types.value AS court_type,
                ARRAY_AGG(DISTINCT decree_natures.value) FILTER (WHERE decree_natures.value IS NOT NULL) AS natures,
                ARRAY_AGG(DISTINCT legislation_areas.value) FILTER (WHERE legislation_areas.value IS NOT NULL) AS areas,
                ARRAY_AGG(DISTINCT legislation_subareas.value) FILTER (WHERE legislation_subareas.value IS NOT NULL) AS subareas,
                ARRAY_AGG(DISTINCT legislations.value) FILTER (WHERE legislations.value IS NOT NULL) AS legislations,
                ARRAY_TO_STRING(
                  (
                    SELECT ARRAY_AGG(decree_pages.text ORDER BY decree_pages.number ASC) FROM decree_pages
                    WHERE decree_pages.decree_id = decrees.id AND decree_pages.number <= 2
                    GROUP BY decree_pages.decree_id
                  ),
                  ''
                ) AS text
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

              WHERE decrees.id > %s -- AND decrees.embedding IS NULL
              GROUP BY decrees.id, decree_forms.value, courts.name, court_types.value
              ORDER BY decrees.id, decree_forms.value, courts.name, court_types.value
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


def store_decrees_embeddings(values):
    start_time = time()
    cur = db.cursor()

    cur.executemany(
        "UPDATE decrees SET embedding = %s WHERE id = %s",
        values,
    )

    db.commit()

    time_in_ms = (time() - start_time) * 1000
    logger.info(f"Stored [{len(values)}] embeddings in [{time_in_ms:.2f}ms]")


def disconnect():
    db.close()
