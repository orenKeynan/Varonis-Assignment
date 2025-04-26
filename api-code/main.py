# main.py
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime


class Restaurant(BaseModel):
    name: str
    style: str
    address: str
    openHour: str  # in HH:MM format
    closeHour: str  # in HH:MM format
    vegetarian: bool

app = FastAPI()

# Sample restaurant data
restaurants: List[Restaurant] = [
    Restaurant(
        name="Pizza Hut",
        style="Italian",
        address="wherever street 99, somewhere",
        openHour="09:00",
        closeHour="23:00",
        vegetarian=False
    ),
    Restaurant(
        name="Green Garden",
        style="Korean",
        address="123 Seoul St, Korea City",
        openHour="11:00",
        closeHour="22:00",
        vegetarian=True
    ),
    # Add more restaurants as needed
]

def is_open(restaurant: Restaurant) -> bool:
    now = datetime.now().time()
    open_time = datetime.strptime(restaurant.openHour, "%H:%M").time()
    close_time = datetime.strptime(restaurant.closeHour, "%H:%M").time()
    return open_time <= now <= close_time

@app.get("/recommendation")
async def get_recommendation(
    style: Optional[str] = None,
    vegetarian: Optional[bool] = None
):
    # Filter by style, vegetarian preference, and open now
    filtered = [r for r in restaurants
                if (style is None or r.style.lower() == style.lower())
                and (vegetarian is None or r.vegetarian == vegetarian)
                and is_open(r)]
    if not filtered:
        raise HTTPException(status_code=404, detail="No restaurant found matching criteria")
    # return the first match
    return {"restaurantRecommendation": filtered[0].dict()}

@app.get("/healthz")
async def healthz():
    """
    Health check endpoint. 
    Returns HTTP 200 with a simple JSON payload if the app is up.
    """
    return {"status": "ok"}
