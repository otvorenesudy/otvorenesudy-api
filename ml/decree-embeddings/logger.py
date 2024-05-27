import logging
import sys

logger = logging.getLogger("decree-embeddings")

logger.setLevel(logging.DEBUG)

handler = logging.StreamHandler(sys.stdout)
handler.setLevel(logging.DEBUG)
logger.addHandler(handler)

formatter = logging.Formatter("%(asctime)s [%(name)s] :: [%(levelname)s] %(message)s")
handler.setFormatter(formatter)
