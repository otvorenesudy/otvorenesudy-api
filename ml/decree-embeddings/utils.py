import re


def batched(iterable, n=1):
    l = len(iterable)
    for ndx in range(0, l, n):
        yield iterable[ndx : min(ndx + n, l)]


def prepare_text(row):
    text = f"""
      {row["form"] or ""}
      {", ".join(row["natures"] or [])}
      {", ".join(row["areas"] or [])}
      {", ".join(row["subareas"] or [])}
      {", ".join(row["legislations"] or [])}

      {row["text"]}
    """

    return re.sub(r"\s+", " ", text).lower().strip()
