import os
import random
from time import time

import numpy
import repository
from embedding import plain_embed_decrees
from repository import decrees
from sentence_transformers import InputExample, SentenceTransformer, losses, models
from sklearn.metrics.pairwise import cosine_similarity
from torch.utils.data import DataLoader

embedding_model = models.Transformer("gerulata/slovakbert")
pooling_model = models.Pooling(
    embedding_model.get_word_embedding_dimension(),
    pooling_mode="weightedmean",
)

model = SentenceTransformer(modules=[embedding_model, pooling_model], device="cpu")


if __name__ == "__main__":
    try:
        data = [decree for batch in decrees() for decree in batch]
        data = plain_embed_decrees(data)

        training_examples = []
        number_of_samples = int(os.getenv("SAMPLES"))

        for _ in range(number_of_samples):
            pair = random.sample(data, 2)

            similarity = numpy.float32(
                cosine_similarity([pair[0]["vector"]], [pair[1]["vector"]])[0][0]
            )

            training_examples.append(
                InputExample(
                    texts=[decree["text"] for decree in pair], label=similarity
                )
            )

        training_dataloader = DataLoader(training_examples, shuffle=True, batch_size=16)
        training_loss = losses.CosineSimilarityLoss(model=model)

        model.fit(
            [(training_dataloader, training_loss)],
            epochs=10,
        )

        model.save(
            f"{os.path.dirname(os.path.abspath(__file__))}/model/gerulata-slovakbert-otvorenesudy-decree-embeddings"
        )
    finally:
        repository.disconnect()
