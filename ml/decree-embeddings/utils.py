import os
import random
import re


def batched(iterable, n=1):
    l = len(iterable)
    for ndx in range(0, l, n):
        yield iterable[ndx : min(ndx + n, l)]


def prepare_text(row):
    text = f"""
      {row["form"] or ""}
      {", ".join(row["natures"] or [])}
      {", ".join(row["legislation_areas"] or [])}
      {", ".join(row["legislation_subareas"] or [])}
      {", ".join(row["legislations"] or [])}

      {row["text"]}
    """

    return re.sub(r"\s+", " ", text).lower().strip()


def batch_files(path, randomize_order=False):
    files = os.listdir(path)

    if randomize_order:
        random.shuffle(files)

    for filename in files:
        file_path = os.path.join(path, filename)

        if os.path.isfile(file_path):
            with open(file_path, "r") as f:
                content = f.read()

            yield file_path, content
