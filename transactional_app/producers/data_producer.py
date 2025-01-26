"""Base class for any producer"""
from abc import abstractmethod

from common.abstract_app import AbstractDataApp
from common.logger import get_logger

from generators.csv_generator import CSVGenerator
from generators.json_generator import JSONGenerator
from generators.abstract_generator import AbstractGenerator

from serializers.json_serializer import JSONSerializer

from writers.abstract_writer import AbstractWriter
from writers.console_writer import ConsoleWriter
from writers.gcs_writer import GCSWriter
from writers.kafka_writer import KafkaWriter


class AbstractDataProducer(AbstractDataApp):
    def __init__(self, config: dict = None) -> None:
        self.config = config
        self.logger = get_logger(self.__class__.__name__)
        self.generator = self._get_generator(config["generator"].get("properties", {}),
                                             config["generator"].get("format", "JSON"))
        self.writer = self._get_writer(config["writer"].get("properties", {}),
                                       config["writer"].get("type", "KAFKA"))

    @abstractmethod
    def run(self):
        raise NotImplementedError

    def _get_generator(self, properties: dict, fmt: str) -> AbstractGenerator:
        match fmt:
            case "JSON":
                return JSONGenerator(properties)
            case "CSV":
                return CSVGenerator(properties)
            case _:
                raise NotImplementedError(f"Generator of format {fmt} is not supported")

    def _get_writer(self, properties: dict, writer_type: str) -> AbstractWriter:
        match writer_type:
            case "KAFKA":
                return KafkaWriter(properties, JSONSerializer)
            case "GCS":
                return GCSWriter(properties)
            case "CONSOLE":
                return ConsoleWriter()
            case _:
                raise NotImplementedError(f"Writer of type {writer_type} is not supported")
