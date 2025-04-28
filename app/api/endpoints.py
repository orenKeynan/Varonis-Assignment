from fastapi import APIRouter, HTTPException, Request
from typing import Optional, List
from app.models.restaurant import Restaurant, RestaurantResponse
from app.db.connection import get_db_connection, return_connection
from app.db.queries import get_restaurants_from_db
from app.core.logging_config import logger

router = APIRouter()

@router.get("/recommendation", response_model=RestaurantResponse)
async def get_recommendation(
    style: Optional[str] = None,
    vegetarian: Optional[bool] = None,
    delivery: Optional[bool] = None,
    open_now: bool = True
):
    """
    Get restaurant recommendations based on criteria
    - **style**: Cuisine style (e.g., Italian, Korean)
    - **vegetarian**: Whether the restaurant offers vegetarian options
    - **delivery**: Whether the restaurant offers delivery
    - **open_now**: Whether the restaurant is currently open
    """
    conn = None
    try:
        conn = get_db_connection()
        
        # Get matching restaurants from database
        filtered = get_restaurants_from_db(conn, style, vegetarian, delivery, open_now)
        
        if not filtered:
            logger.info(f"No restaurant found matching criteria: style={style}, vegetarian={vegetarian}, delivery={delivery}, open_now={open_now}")
            raise HTTPException(status_code=404, detail="No restaurant found matching criteria")
        
        # Return first match as recommended restaurant
        result = {"restaurantRecommendation": filtered[0]}
        logger.info(f"Recommendation returned: {filtered[0]['name']}")
        
        return result
        
    except HTTPException:
        # Re-raise HTTP exceptions
        raise
    except Exception as e:
        logger.error(f"Unexpected error in get_recommendation: {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")
    finally:
        if conn:
            return_connection(conn)

@router.get("/restaurants", response_model=List[Restaurant])
async def get_all_restaurants(request: Request):
    """Get all restaurants in the database"""
    conn = None
    try:
        conn = get_db_connection()
        restaurants = get_restaurants_from_db(conn)
        logger.info(f"Retrieved {len(restaurants)} restaurants")
        return restaurants
    except Exception as e:
        logger.error(f"Unexpected error in get_all_restaurants: {str(e)}")
        raise HTTPException(status_code=500, detail="Internal server error")
    finally:
        if conn:
            return_connection(conn)

@router.get("/healthz")
async def healthz(request: Request):
    """
    Health check endpoint. 
    Returns HTTP 200 with a simple JSON payload if the app is up.
    """
    conn = None
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute("SELECT 1")
        cursor.fetchone()
        return {"status": "ok", "database": "connected"}
    except Exception as e:
        logger.error(f"Health check failed: {str(e)}")
        return {"status": "error", "database": "disconnected", "message": "Database connection failed"}
    finally:
        if conn:
            return_connection(conn)