import json
import os
import random
from time import time

import numpy
from embedding import base_embed_decrees
from logger import logger
from sentence_transformers import InputExample, SentenceTransformer, losses, models
from sklearn.metrics.pairwise import cosine_similarity
from torch.utils.data import DataLoader
from utils import batch_files

# TODO: to be implemented

embedding_model = models.Transformer("gerulata/slovakbert")
pooling_model = models.Pooling(
    embedding_model.get_word_embedding_dimension(),
    pooling_mode="weightedmean",
)

model = SentenceTransformer(modules=[embedding_model, pooling_model], device="cpu")

if __name__ == "__main__":
    training_examples = []
    number_of_sample_files = int(os.getenv("SAMPLE_FILES"))
    sample_files = []
    data = []

    data_start_time = time()

    for file_path, content in batch_files(
        os.path.join(os.getenv("DATA_PATH"), "data"), randomize_order=True
    ):
        sample_files.append(file_path)
        data = data + json.loads(content)

        if len(sample_files) == number_of_sample_files:
            break

    data_time_in_ms = (time() - data_start_time) * 1000
    logger.info(
        f"Sampled [{len(data)}] decrees from [{len(sample_files)}] files in [{data_time_in_ms:.2f}ms]"
    )

    training_examples_start_time = time()

    for _ in range(0, len(data)):
        pair = random.sample(data, 2)

        similarity = numpy.float32(
            cosine_similarity(
                [pair[0]["__scaled_base_embedding__"]],
                [pair[1]["__scaled_base_embedding__"]],
            )[0][0]
        )

        training_examples.append(
            InputExample(texts=[decree["text"] for decree in pair], label=similarity)
        )

    training_examples_time_in_ms = (time() - training_examples_start_time) * 1000

    logger.info(
        f"Built [{len(training_examples)}] training examples pairs in [{training_examples_time_in_ms:.2f}ms]"
    )

    training_dataloader = DataLoader(training_examples, shuffle=True, batch_size=16)
    training_loss = losses.CosineSimilarityLoss(model=model)

    model.fit(
        [(training_dataloader, training_loss)],
        epochs=10,
    )

    model.save(
        f"{os.path.dirname(os.path.abspath(__file__))}/models/gerulata-slovakbert-otvorenesudy-decree-embeddings"
    )
