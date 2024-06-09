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


def csr_matrix_memory_in_bytes(csr_matrix):
    data_memory = csr_matrix.data.nbytes
    indices_memory = csr_matrix.indices.nbytes
    indptr_memory = csr_matrix.indptr.nbytes

    return data_memory + indices_memory + indptr_memory
