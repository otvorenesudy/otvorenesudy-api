import json
import os
from datetime import datetime
from time import time

import numpy as np
from logger import logger
from scipy.sparse import csr_matrix, hstack
from sklearn.feature_extraction.text import CountVectorizer


def encode_year(year):
    min_year = 1960
    max_year = datetime.now().year
    year_range = max_year - min_year
    year_fraction = (year - min_year) / year_range
    sine_encoding = np.sin(2 * np.pi * year_fraction)
    cosine_encoding = np.cos(2 * np.pi * year_fraction)
    return [sine_encoding, cosine_encoding]


def decree_to_base_features(decree):
    return [
        item
        for item in [
            decree["form"] or None,
            decree["court_type"] or None,
            *(decree["natures"] or []),
            *(decree["legislation_areas"] or []),
            *(decree["legislation_subareas"] or []),
            *(decree["legislations"] or []),
        ]
        if item
    ]


def decrees_to_embeddings(vocabulary, decrees):
    features = [decree_to_base_features(decree) for decree in decrees]

    vectorizer = CountVectorizer(
        vocabulary=vocabulary,
        lowercase=False,
        token_pattern=None,
        tokenizer=lambda x: x,
    )

    vectors = vectorizer.fit_transform(features)
    encoded_years = csr_matrix([encode_year(decree["year"]) for decree in decrees])

    return hstack((encoded_years, vectors))
