from producers.base_producer import BaseProducer


class BatchProducer(BaseProducer):
    """Producer of batch files for saving them locally"""
    def __init__(self, producer_type: str = "BATCH", config: dict = None) -> None:
        super().__init__(producer_type, config)

    def run(self):
        output_path = self.generator.generate()
        self.writer.write(output_path)
