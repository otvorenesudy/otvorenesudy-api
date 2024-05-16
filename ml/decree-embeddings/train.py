import os
import random
from time import time

from logger import logger
from repository import training_decrees
from sentence_transformers import InputExample, SentenceTransformer, losses, models
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from torch.utils.data import DataLoader

embedding_model = models.Transformer("gerulata/slovakbert")
pooling_model = models.Pooling(
    embedding_model.get_word_embedding_dimension(),
    pooling_mode="weightedmean",
)

model = SentenceTransformer(modules=[embedding_model, pooling_model], device="cpu")


def decree_to_training_feature(decree):
    return [
        item
        for item in [
            decree["form"] or None,
            *(decree["natures"] or []),
            *(decree["areas"] or []),
            *(decree["subareas"] or []),
            *(decree["legislations"] or []),
        ]
        if item
    ]


if __name__ == "__main__":
    decrees = [
        {**decree, "features": decree_to_training_feature(decree)}
        for decree in training_decrees(count=1000)
    ]

    vectorizer = CountVectorizer(tokenizer=lambda x: x)

    vectorizer_fit_start_time = time()

    vectorizer.fit([value for d in decrees for value in d["features"]])

    vectorizer_fit_time_in_ms = (time() - vectorizer_fit_start_time) * 1000

    logger.debug(
        f"Vectorized [{len(vectorizer.get_feature_names_out())}] features in [{vectorizer_fit_time_in_ms:.2f}ms]"
    )

    for decree in decrees:
        decree["vector"] = vectorizer.transform(decree["features"]).toarray()

    print(vectorizer.get_feature_names_out())
    print(decrees[0]["features"])

    training_examples = []

    for _ in range(1000):
        pair = random.sample(decrees, 2)

        similarity = cosine_similarity([pair[0]["vector"]], [pair[1]["vector"]])

        training_examples.append(
            InputExample(texts=[decree["text"] for decree in decrees], label=similarity)
        )

    training_batch_size = 1
    training_dataloader = DataLoader(
        training_examples, shuffle=True, batch_size=training_batch_size
    )
    training_loss = losses.CosineSimilarityLoss(model=model)

    model.fit(
        [(training_dataloader, training_loss)],
        epochs=10,
    )

    model.save("./model/gerulata-slovakbert-otvorenesudy-decree-embeddings")
