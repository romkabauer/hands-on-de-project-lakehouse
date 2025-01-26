import csv
import os
from dataclasses import astuple

from common.exceptions import SazmpleSizeParameterError
from common.models import IncomeRecord
from generators.abstract_generator import AbstractGenerator


class CSVGenerator(AbstractGenerator):
    """Class for CSV data generation"""

    def generate(self):
        include_header = bool(int(self.properties.get("include_header", True)))
        try:
            sample_size = int(self.properties["sample_size_records"])
        except TypeError as e:
            raise SazmpleSizeParameterError from e

        temp_path = "/tmp/generator/csv/tmp_data.csv"
        os.makedirs(os.path.split(temp_path)[0], exist_ok=True)

        with open(temp_path, "w+", encoding="UTF-8") as csv_stream:
            csv_writer = csv.writer(csv_stream)
            if include_header:
                csv_writer.writerow(IncomeRecord.__annotations__.keys())
            for _ in range(sample_size):
                rec = astuple(IncomeRecord(
                    self._generate_uuid(),
                    self._generate_from_set(["USA", "Germany", "Turkey", "Russia", "Georgia"]),
                    self._generate_from_set(["Salary", "Passive Income"]),
                    round(self._generate_from_dist(), 4),
                    self._generate_from_set(["USD", "EUR", "TRY", "RUB", "GEL"])
                ))
                csv_writer.writerow(rec)
        return temp_path
