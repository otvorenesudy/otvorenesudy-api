import json
import math
import os
import pickle as pk
from time import time

import numpy as np
from embedding import decrees_to_embeddings
from logger import logger
from repository import repository
from scipy.sparse import vstack
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.random_projection import GaussianRandomProjection
from utils import csr_matrix_memory_in_bytes

if __name__ == "__main__":
    try:
        model_path = os.path.join(
            os.path.dirname(os.path.abspath(__file__)), "models", "reducer.pk"
        )
        incremental = os.getenv("INCREMENTAL", "false").lower() == "true"

        if incremental:
            logger.info("Incremental mode enabled")

        vocabulary = repository.decrees_vocabulary()

        logger.info(f"Loaded vocabulary with [{len(vocabulary)}] values")
        logger.debug(f"Vocabulary sample: {vocabulary[:10]} ...")

        embeddings_start_time = time()
        ids = []
        embeddings = []

        for batch in repository.decrees(without_embedding_only=incremental):
            start_time = time()

            vectors = decrees_to_embeddings(vocabulary, batch)

            time_in_ms = (time() - start_time) * 1000

            logger.info(
                f"Finished a batch of embeddings in [{time_in_ms:.2f}ms] for [{len(batch)}] decrees"
            )

            ids.extend([decree["id"] for decree in batch])
            embeddings.append(vectors)

        if len(embeddings) == 0:
            logger.info("No embeddings to process")
            exit(0)

        embeddings = vstack(embeddings)

        embeddings_time_in_ms = (time() - embeddings_start_time) * 1000

        logger.info(f"Finished embeddings in [{embeddings_time_in_ms:.2f}ms]")

        if incremental:
            logger.info(f"Loading reducer model from [{model_path}] ...")

            reducer_start_time = time()

            with open(model_path, "rb") as f:
                reducer = pk.load(f)

            reducer_time_in_ms = (time() - reducer_start_time) * 1000

            logger.info(f"Reducer model loaded in [{reducer_time_in_ms:.2f}ms]")
        else:
            memory = csr_matrix_memory_in_bytes(embeddings)

            logger.debug(
                f"Memory usage for embeddings is [{memory / 1024 / 1024:.2f}MB]"
            )

            sparsity = 1.0 - (
                embeddings.count_nonzero() / (embeddings.shape[0] * embeddings.shape[1])
            )
            eps = math.floor(sparsity / 0.05) * 0.05

            logger.info(f"Sparsity of embeddings is [{sparsity}]")
            logger.info(f"Setting eps of GaussianRandomProjection to [{eps}]")

            reducer = GaussianRandomProjection(n_components=768, eps=eps)

            reducer_start_time = time()
            reducer.fit(embeddings)
            reducer_time_in_ms = (time() - reducer_start_time) * 1000

            logger.info(
                f"Finished fitting dimensionality reduction for embeddings in [{reducer_time_in_ms:.2f}ms]"
            )

            with open(model_path, "wb") as f:
                pk.dump(reducer, f)

            logger.info(f"Reducer model saved to [{model_path}]")

        batch_size = 10_000

        testing_embeddings = []
        testing_reduced_embeddings = []

        for i in range(0, embeddings.shape[0], batch_size):
            start_time = time()

            embeddings_batch = embeddings[i : i + batch_size]
            ids_batch = ids[i : i + batch_size]
            reduced_embeddings = reducer.transform(embeddings_batch)

            repository.store_decrees_embeddings(
                [
                    {"id": id, "embedding": embedding.tolist()}
                    for id, embedding in zip(ids_batch, reduced_embeddings)
                ],
            )

            time_in_ms = (time() - start_time) * 1000

            # size min of 100 or embeddings_batch.shape[0]
            size = min(100, embeddings_batch.shape[0])

            testing_indices = np.random.choice(
                embeddings_batch.shape[0], size=size, replace=False
            )

            testing_embeddings.append(embeddings_batch[testing_indices, :])
            testing_reduced_embeddings.append(reduced_embeddings[testing_indices, :])

            logger.info(
                f"Stored [#{ i // batch_size}] batch of embeddings in [{time_in_ms:.2f}ms]"
            )

        similarities = cosine_similarity(vstack(testing_embeddings))
        reduced_similarities = cosine_similarity(
            np.concatenate(testing_reduced_embeddings)
        )

        differences = np.abs(similarities - reduced_similarities)

        logger.info(f"Error rate: {np.mean(differences) / np.mean(similarities)}")
        logger.info(
            f"Mean difference between cosine similarities: {np.mean(differences)}"
        )
        logger.info(
            f"Median difference between cosine similarities: {np.median(differences)}"
        )
        logger.info(
            f"Standard deviation of differences between cosine similarities: {np.std(differences)}"
        )
        logger.info(
            f"Maximum difference between cosine similarities: {np.max(differences)}"
        )
        logger.info(
            f"Minimum difference between cosine similarities: {np.min(differences)}"
        )
        logger.info(
            f"Variance of differences between cosine similarities: {np.var(differences)}"
        )
    finally:
        repository.disconnect()
