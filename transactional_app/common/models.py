"""Data models used by producer"""
from dataclasses import dataclass

@dataclass
class BaseRecord:
    pass

@dataclass
class ExpenseRecord:
    user_id: str
    user_country: str
    category: str
    amount: int
    currency: str
    custom_message: str

@dataclass
class IncomeRecord:
    user_id: str
    user_country: str
    source: str
    amount: int
    currency: str
