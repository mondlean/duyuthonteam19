from pydantic import BaseModel
from typing import List

class ItemResponse(BaseModel):

    name: str
    price: int
    category: str
    eco: bool
    tags: List[str]
    point: int


class OCRResponse(BaseModel):

    success: bool

    items: List[ItemResponse]

    total_price: int
    total_point: int

    plant_status: str