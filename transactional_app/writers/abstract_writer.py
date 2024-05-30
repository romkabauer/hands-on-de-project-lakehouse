from abc import ABC, abstractmethod


class AbstractWriter(ABC):
    def __init__(self):
        pass

    @abstractmethod
    def write(self, message):
        raise NotImplementedError
