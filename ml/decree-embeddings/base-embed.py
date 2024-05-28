import json
import os
from time import time

import pandas as pd
from embedding import base_embed_decrees
from logger import logger
from sklearn.decomposition import IncrementalPCA
from sklearn.preprocessing import StandardScaler
from utils import batch_files, batched

if __name__ == "__main__":
    path = os.getenv("DATA_PATH")

    with open(os.path.join(path, "vocabulary.json"), "r") as f:
        vocabulary = json.load(f)

    scaler = StandardScaler()
    pca = IncrementalPCA(n_components=768)

    partial_scaling_start_time = time()

    for file_path, content in batch_files(os.path.join(path, "data")):
        start_time = time()

        data = json.loads(content)
        embeddings = base_embed_decrees(vocabulary, data)

        scaler.partial_fit(embeddings)

        for i, embedding in enumerate(embeddings):
            data[i]["__base_embedding__"] = embedding.tolist()

        with open(file_path, "w") as f:
            json.dump(data, f)

        time_in_ms = (time() - start_time) * 1000

        logger.info(
            f"Finished a batch of partially scaled embeddings in [{time_in_ms:.2f}ms] for [{len(data)}] decrees"
        )

    partial_scaling_time_in_ms = (time() - partial_scaling_start_time) * 1000

    logger.info(
        f"Finished partially scaled embeddings in [{partial_scaling_time_in_ms:.2f}ms]"
    )

    partial_pca_start_time = time()

    for file_path, content in batch_files(os.path.join(path, "data")):
        start_time = time()

        data = json.loads(content)
        embeddings = [decree["__base_embedding__"] for decree in data]
        scaled_embeddings = scaler.transform(embeddings)

        pca.partial_fit(scaled_embeddings)

        for i, embedding in enumerate(scaled_embeddings):
            data[i]["__scaled_base_embedding__"] = embedding.tolist()

        with open(file_path, "w") as f:
            json.dump(data, f)

        time_in_ms = (time() - start_time) * 1000

        logger.info(
            f"Finished a batch of partially PCA transformed embeddings in [{time_in_ms:.2f}ms] for [{len(data)}] decrees"
        )

    partial_pca_time_in_ms = (time() - partial_pca_start_time) * 1000

    logger.info(
        f"Finished partially PCA transformed embeddings in [{partial_pca_time_in_ms:.2f}ms]"
    )

    pca_start_time = time()

    for file_path, content in batch_files(os.path.join(path, "data")):
        start_time = time()

        data = json.loads(content)
        embeddings = [decree["__scaled_base_embedding__"] for decree in data]
        reduced_embeddings = pca.transform(embeddings)

        for i, embedding in enumerate(reduced_embeddings):
            data[i]["base_embedding"] = embedding.tolist()

        with open(file_path, "w") as f:
            json.dump(data, f)

        time_in_ms = (time() - start_time) * 1000

        logger.info(
            f"Finished a batch of PCA transformed embeddings in [{time_in_ms:.2f}ms] for [{len(data)}] decrees"
        )

    pca_time_in_ms = (time() - pca_start_time) * 1000

    logger.info(f"Finished PCA transformed embeddings in [{pca_time_in_ms:.2f}ms]")
