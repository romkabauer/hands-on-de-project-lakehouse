from producers.data_producer import AbstractDataProducer


class BatchProducer(AbstractDataProducer):
    """Producer of batch files for saving them locally"""
    def __init__(self, config: dict = None) -> None:
        super().__init__(config)

    def run(self):
        output_path = self.generator.generate()
        self.writer.write(output_path)
