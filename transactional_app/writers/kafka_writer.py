from kafka import KafkaProducer
from serializers.abstract_serializer import AbstractSerializer
from writers.abstract_writer import AbstractWriter


class KafkaWriter(AbstractWriter):
    def __init__(self, properties: dict, serializer: AbstractSerializer):
        self.server = properties.get("kafka_server", "localhost:9092")
        self.topic = properties["kafka_topic_name"]
        self.kafka_producer = KafkaProducer(
            bootstrap_servers=[self.server],
            value_serializer=serializer.serialize,
        )

    def write(self, message):
        self.kafka_producer.send(topic=self.topic, value=message)
