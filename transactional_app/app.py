import os

from common.abstract_app import AbstractDataApp
from producers.base_producer import BaseProducer
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
            # case "CONSUMER":
            #     return self._build_consumer()
            case _:
                raise NotImplementedError(f"Unsupported application type '{self.app_type}'")

    def _build_producer(self) -> BaseProducer:
        producer_type = os.environ["PRODUCER_TYPE"]
        match producer_type:
            case "EVENT":
                config = {
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
                return EventProducer(producer_type, config)
            case "BATCH":
                config = {
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
                        }
                    },
                    "producer": {}
                }
                return BatchProducer(producer_type, config)
            case _:
                raise NotImplementedError(f"Producer of type {producer_type} is not supported")

    # def _build_consumer(self):
    #     pass
