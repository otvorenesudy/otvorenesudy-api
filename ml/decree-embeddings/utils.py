import re


def prepare_text(row):
    text = row["text"]
    match = re.search(r"ecli:.+?$", text, re.MULTILINE | re.IGNORECASE)

    if match:
        text = text[match.end() :]

    text = f"""
      {row["form"] or ""}
      {", ".join(row["natures"] or [])}
      {", ".join(row["areas"] or [])}
      {", ".join(row["subareas"] or [])}
      {", ".join(row["legislations"] or [])}

      {text}
    """

    return re.sub(r"\s+", " ", text).lower().strip()
