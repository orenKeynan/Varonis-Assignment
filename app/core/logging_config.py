import logging

def configure_logging():
    """Configure production-level logging to stdout/stderr"""
    logging.basicConfig(
        level=logging.INFO,
        format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
    )
    logger = logging.getLogger("restaurant-api")
    return logger

logger = configure_logging()