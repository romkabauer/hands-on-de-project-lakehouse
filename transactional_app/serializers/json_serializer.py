"""Class for serializing to json"""


import json
from serializers.base_serializer import AbstractSerializer


class JSONSerializer(AbstractSerializer):
    """Class for serializing objects to JSON"""
    @staticmethod
    def serialize(obj: dict):
        return json.dumps(obj, indent=4).encode("utf-8")
