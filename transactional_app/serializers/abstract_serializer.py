"""Base class for serializers"""


from abc import ABC
from typing import Any


class AbstractSerializer(ABC):
    @staticmethod
    def serialize(obj: Any):
        """Serializing object to particular format"""
        raise NotImplementedError
