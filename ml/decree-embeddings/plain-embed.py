from itertools import batched
from time import time

import pandas as pd
import repository
from embedding import plain_embed_decrees
from logger import logger
from repository import decrees, store_decrees_embeddings
from sklearn.decomposition import PCA
from sklearn.preprocessing import StandardScaler

if __name__ == "__main__":
    try:
        data = [decree for batch in decrees() for decree in batch]
        data = plain_embed_decrees(data)

        standardize_start_time = time()

        scalar = StandardScaler()
        scaled_vectors = pd.DataFrame(
            scalar.fit_transform([decree["vector"] for decree in data])
        )

        standardize_time_in_ms = (time() - standardize_start_time) * 1000

        logger.info(
            f"Standardized [{len(scaled_vectors)}] vectors in [{standardize_time_in_ms:.2f}ms]"
        )

        pca_start_time = time()
        pca = PCA(n_components=768)
        pca.fit(scaled_vectors)
        embeddings = pca.transform(scaled_vectors)

        pca_time_in_ms = (time() - pca_start_time) * 1000

        logger.info(
            f"Reduced dimensionality of [{len(embeddings)}] vectors using PCA in [{pca_time_in_ms:.2f}ms]"
        )

        for batch in batched(zip(embeddings, data), 1000):
            store_decrees_embeddings(
                [[embedding.tolist(), data["id"]] for embedding, data in batch]
            )
    finally:
        repository.disconnect()
