from pydantic import BaseModel
from typing import Optional

class Restaurant(BaseModel):
    name: str
    style: str
    address: str
    openHour: str  # in HH:MM format
    closeHour: str  # in HH:MM format
    vegetarian: bool
    delivery: Optional[bool] = False

class RestaurantResponse(BaseModel):
    restaurantRecommendation: Restaurant