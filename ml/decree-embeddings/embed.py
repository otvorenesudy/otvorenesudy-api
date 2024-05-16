from time import time

from logger import logger
from repository import decrees, store_decrees_embeddings
from sentence_transformers import SentenceTransformer, models
from utils import prepare_text

embedding_model = models.Transformer("gerulata/slovakbert")
pooling_model = models.Pooling(
    embedding_model.get_word_embedding_dimension(),
    pooling_mode="weightedmean",
)

model = SentenceTransformer(modules=[embedding_model, pooling_model], device="cpu")


def embed(texts):
    start_time = time()

    embeddings = model.encode(texts, batch_size=25, show_progress_bar=True)

    time_in_ms = (time() - start_time) * 1000

    logger.info(f"Embedded [{len(texts)}] texts in [{time_in_ms:.2f}ms]")

    return embeddings


if __name__ == "__main__":
    for batch in decrees():
        texts = [prepare_text(row) for row in batch]

        embeddings = embed(texts)

        store_decrees_embeddings(
            [
                [embedding.tolist(), row["id"]]
                for embedding, row in zip(embeddings, batch)
            ]
        )
