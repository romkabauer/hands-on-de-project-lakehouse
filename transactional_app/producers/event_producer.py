import time

from common.exceptions import (
    EventFrequencyParameterError
)
from producers.data_producer import AbstractDataProducer


class EventProducer(AbstractDataProducer):
    """Producer of events for sending them to Kafka"""

    def run(self):
        while True:
            try:
                freq = int(self.config["producer"]["frequency_sec"])
            except TypeError as e:
                raise EventFrequencyParameterError from e

            time.sleep(freq)
            event = self.generator.generate()
            self.logger.info("Sending event...\n%s", event)
            self.writer.write(event)
