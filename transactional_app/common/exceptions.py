"""Exception used in producer app"""


class EventFrequencyParameterError(Exception):
    """Should be used when PRODUCER_EVENT_FREQUENCY env variable is not integer"""
    def __init__(self) -> None:
        super().__init__("Value of PRODUCER_EVENT_FREQUENCY env variable cannot be interpreted as integer")

class SazmpleSizeParameterError(Exception):
    """Should be used when BATCH_SAMPLE_SIZE env variable is not integer"""
    def __init__(self) -> None:
        super().__init__("Value of BATCH_SAMPLE_SIZE env variable cannot be interpreted as integer")
