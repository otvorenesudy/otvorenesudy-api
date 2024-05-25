from time import time

from logger import logger
from sklearn.feature_extraction.text import CountVectorizer


def decree_to_plain_features(decree):
    return [
        item
        for item in [
            decree["form"] or None,
            decree["court_type"] or None,
            *(decree["natures"] or []),
            *(decree["areas"] or []),
            *(decree["subareas"] or []),
            *(decree["legislations"] or []),
        ]
        if item
    ]


def plain_embed_decrees(decrees):
    data = [
        {**decree, "features": decree_to_plain_features(decree)} for decree in decrees
    ]

    vectorizer = CountVectorizer(
        tokenizer=lambda x: x,
        analyzer=lambda x: x,
        lowercase=False,
        token_pattern=None,
    )

    vectorizer_fit_start_time = time()

    vectors = vectorizer.fit_transform([decree["features"] for decree in data])

    vectorizer_fit_time_in_ms = (time() - vectorizer_fit_start_time) * 1000

    logger.info(
        f"Vectorized [{len(vectorizer.get_feature_names_out())}] features in [{vectorizer_fit_time_in_ms:.2f}ms]"
    )

    logger.debug("Vectorized features:")
    logger.debug(vectorizer.get_feature_names_out().tolist())

    for i, decree in enumerate(data):
        decree["vector"] = vectors[i].toarray()[0]

    return data
