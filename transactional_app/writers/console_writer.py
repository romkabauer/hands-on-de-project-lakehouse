from common.logger import get_logger
from writers.abstract_writer import AbstractWriter


class ConsoleWriter(AbstractWriter):
    logger = get_logger()

    def write(self, message):
        self.logger.info("Message written: %s", message)
