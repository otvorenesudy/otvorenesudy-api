import re


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


def decree_to_features(decree):
    return [
        item
        for item in [
            decree["form"] or None,
            decree["court"] or None,
            *(decree["natures"] or []),
            *(decree["areas"] or []),
            *(decree["subareas"] or []),
            *(decree["legislations"] or []),
        ]
        if item
    ]
