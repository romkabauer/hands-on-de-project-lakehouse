import os

from common.abstract_app import AbstractDataApp
from producers.data_producer import AbstractDataProducer
from producers.batch_producer import BatchProducer
from producers.event_producer import EventProducer


class DataAppBuilder:
    """Class for setting application up for further usage"""
    def __init__(self) -> None:
        self.app_type = os.environ["APPLICATION_TYPE"]

    def build(self) -> AbstractDataApp:
        match self.app_type:
            case "PRODUCER":
                return self._build_producer()
            # TODO: Implement sample consumer
            # case "CONSUMER":
            #     return self._build_consumer()
            case _:
                raise NotImplementedError(f"Unsupported application type '{self.app_type}'")

    def _build_producer(self) -> AbstractDataProducer:
        producer_type = os.environ["PRODUCER_TYPE"]
        producer = self._build_producer_config(producer_type)
        return producer


    def _build_producer_config(self, producer_type: str) -> AbstractDataProducer:
        match producer_type:
            case "EVENT":
                config = self._build_event_producer_config()
                return EventProducer(config)
            case "BATCH":
                config = self._build_batch_producer_config()
                return BatchProducer(config)
            case _:
                raise NotImplementedError(f"Producer of type {producer_type} is not supported")


    def _build_event_producer_config(self) -> dict:
        return {
            "writer": {
                "type": "KAFKA",
                "properties": {
                    "kafka_topic_name": os.environ["KAFKA_TOPIC_NAME"],
                    "kafka_server": os.environ["KAFKA_SERVER"]
                }
            },
            "generator": {
                "format": os.environ["EVENT_GENERATOR_FORMAT"],
                "properties": {
                    "default_message": os.environ["EVENT_GENERATOR_DEFAULT_MESSAGE"]
                }
            },
            "producer": {
                "frequency_sec": os.environ["PRODUCER_EVENT_FREQUENCY"]
            }
        }


    def _build_batch_producer_config(self) -> dict:
        return {
            "writer": {
                "type": "GCS",
                "properties": {
                    "bucket_name": os.environ["BATCH_WRITER_GCS_BUCKET"],
                    "creds_path": os.environ["GOOGLE_APPLICATION_CREDENTIALS"]
                }
            },
            "generator": {
                "format": os.environ["BATCH_GENERATOR_FORMAT"],
                "properties": {
                    "sample_size_records": os.environ["BATCH_SAMPLE_SIZE"],
                    "include_header": os.environ["BATCH_INCLUDE_HEADER"]
                }
            },
            "producer": {}
        }
