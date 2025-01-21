from dataclasses import asdict
from common.models import ExpenseRecord
from generators.abstract_generator import AbstractGenerator


class JSONGenerator(AbstractGenerator):
    """Class for JSON data generation"""

    def generate(self):
        data = ExpenseRecord(
            user_id=str(self._generate_uuid()),
            user_country=self._generate_from_set(["USA", "Germany", "Turkey", "Russia", "Georgia"]),
            category=self._generate_from_set(["Food", "Eat out", "Rent", "Medicine", "Other"]),
            amount=round(self._generate_from_dist(params=(-2,1)),4),
            currency=self._generate_from_set(["USD", "EUR", "TRY", "RUB", "GEL"]),
            custom_message=self.properties.get("default_message", "Default message")
        )
        return asdict(data)
