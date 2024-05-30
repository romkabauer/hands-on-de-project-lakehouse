from abc import ABC, abstractmethod
import random
import uuid


class AbstractGenerator(ABC):
    def __init__(self, properties: dict = None) -> None:
        self.properties = properties

    @abstractmethod
    def generate(self):
        # TODO: adapt data model choosing
        raise NotImplementedError

    @staticmethod
    def _generate_uuid():
        return uuid.uuid1()

    @staticmethod
    def _generate_from_set(choices: list[str] | tuple[str]):
        return random.choice(choices)

    @staticmethod
    def _generate_from_dist(dist: str = "lognorm", params: tuple[int] = (5.5,2)):
        match dist:
            case "lognorm":
                return random.lognormvariate(*params)
            case _:
                return random.lognormvariate(5.5,2)
