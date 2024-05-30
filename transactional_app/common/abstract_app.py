from abc import ABC, abstractmethod


class AbstractDataApp(ABC):
    @abstractmethod
    def run(self):
        raise NotImplementedError
