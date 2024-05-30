"""Entry point for data producer client"""
from common.logger import get_logger
from app import DataAppBuilder


if __name__ == "__main__":
    logger = get_logger()
    app = DataAppBuilder().build()

    try:
        app.run()
    except Exception as e:
        logger.error("Error occured during data app run: %s", e)
        raise
