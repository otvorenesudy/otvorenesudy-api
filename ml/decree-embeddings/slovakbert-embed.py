import os
from time import time

from logger import logger
from sentence_transformers import SentenceTransformer
from transformers import AutoModel
from utils import prepare_text

current_dir = os.path.dirname(os.path.realpath(__file__))
model = SentenceTransformer(
    f"{current_dir}/model/gerulata-slovakbert-otvorenesudy-decree-embeddings",
    device="cpu",
)


def embed(texts):
    start_time = time()

    embeddings = model.encode(texts, batch_size=25, show_progress_bar=True)

    time_in_ms = (time() - start_time) * 1000

    logger.info(f"Embedded [{len(texts)}] texts in [{time_in_ms:.2f}ms]")

    return embeddings


if __name__ == "__main__":
    # TODO: to be implemented, concatenate embeddings with base + bert
    for batch in decrees():
        texts = [prepare_text(row) for row in batch]

        embeddings = embed(texts)

        store_decrees_embeddings(
            [
                [embedding.tolist(), row["id"]]
                for embedding, row in zip(embeddings, batch)
            ]
        )
