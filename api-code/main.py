from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel
from typing import Optional, List, Dict, Any
from datetime import datetime
import uvicorn
import os
import logging
import pyodbc

# Configure production-level logging to stdout/stderr
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger("restaurant-api")

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

app = FastAPI(title="Restaurant Recommendation API",
              description="API for querying and recommending restaurants based on various criteria")

# Database connection details
DB_SERVER = os.environ.get("DB_SERVER")
DB_NAME = os.environ.get("DB_NAME")
DB_USERNAME = os.environ.get("DB_USERNAME")
DB_PASSWORD = os.environ.get("DB_PASSWORD")

# Connection pool for better performance and reliability
CONNECTION_POOL = []
MAX_POOL_SIZE = 10

def get_db_connection():
    """Get a connection from the pool or create a new one if necessary"""
    if CONNECTION_POOL:
        try:
            conn = CONNECTION_POOL.pop()
            # Test if connection is still valid
            conn.execute("SELECT 1")
            return conn
        except:
            # Connection was stale, create new one
            pass
    
    # Create new connection
    connection_string = f"DRIVER={{ODBC Driver 17 for SQL Server}};SERVER={DB_SERVER};DATABASE={DB_NAME};UID={DB_USERNAME};PWD={DB_PASSWORD};Connection Timeout=30;Encrypt=yes;TrustServerCertificate=no"
    try:
        conn = pyodbc.connect(connection_string)
        return conn
    except Exception as e:
        logger.error(f"Database connection error: {str(e)}")
        raise HTTPException(status_code=503, detail="Database service unavailable")

def return_connection(conn):
    """Return a connection to the pool"""
    if len(CONNECTION_POOL) < MAX_POOL_SIZE:
        try:
            # Make sure connection is still good
            conn.execute("SELECT 1")
            CONNECTION_POOL.append(conn)
        except:
            # If connection is bad, close it
            try:
                conn.close()
            except:
                pass
    else:
        try:
            conn.close()
        except:
            pass

def is_open(restaurant: Dict) -> bool:
    """Check if a restaurant is currently open based on local time"""
    now = datetime.now().time()
    try:
        open_time = datetime.strptime(restaurant["openHour"], "%H:%M").time()
        close_time = datetime.strptime(restaurant["closeHour"], "%H:%M").time()
        
        # Handle cases where restaurant closes after midnight
        if close_time < open_time:
            return open_time <= now or now <= close_time
        return open_time <= now <= close_time
    except ValueError as e:
        logger.error(f"Time format error for restaurant {restaurant.get('name', 'unknown')}: {str(e)}")
        # If time format is invalid, consider restaurant closed
        return False

def get_restaurants_from_db(conn, style=None, vegetarian=None, delivery=None, open_now=False):
    """Query database for restaurants matching criteria with proper protection against SQL injection"""
    try:
        cursor = conn.cursor()
        
        # Build query dynamically based on filters with parameterized queries
        query = "SELECT name, style, address, openHour, closeHour, vegetarian, delivery FROM restaurants WHERE 1=1"
        params = []
        
        # Add filters to query with parameters to prevent SQL injection
        if style:
            query += " AND LOWER(style) = LOWER(?)"
            params.append(style)
        
        if vegetarian is not None:
            query += " AND vegetarian = ?"
            params.append(1 if vegetarian else 0)  # Convert to 1/0 for SQL bit type
            
        if delivery is not None:
            query += " AND delivery = ?"
            params.append(1 if delivery else 0)  # Convert to 1/0 for SQL bit type
        
        # Execute query with parameters
        cursor.execute(query, params)
        
        # Convert query results to list of dictionaries
        columns = [column[0] for column in cursor.description]
        restaurants = []
        for row in cursor.fetchall():
            # Convert SQL bit type (0/1) to Python boolean
            restaurant_dict = dict(zip(columns, row))
            restaurant_dict["vegetarian"] = bool(restaurant_dict["vegetarian"])
            restaurant_dict["delivery"] = bool(restaurant_dict["delivery"])
            restaurants.append(restaurant_dict)
        
        # Filter for open restaurants if requested
        if open_now:
            restaurants = [r for r in restaurants if is_open(r)]
            
        return restaurants
        
    except Exception as e:
        logger.error(f"Database query error: {str(e)}")
        raise HTTPException(status_code=500, detail="Error retrieving restaurant data")

@app.get("/recommendation", response_model=RestaurantResponse)
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

@app.get("/restaurants", response_model=List[Restaurant])
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

@app.get("/healthz")
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

if __name__ == "__main__":
    host = os.getenv("HOST")
    port = int(os.getenv("PORT"))
    uvicorn.run(app, host=host, port=port)
