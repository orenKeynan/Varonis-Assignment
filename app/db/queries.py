from fastapi import HTTPException
from typing import Optional, List, Dict
from app.core.logging_config import logger
from app.utils.time_utils import is_open

def get_restaurants_from_db(conn, style=None, vegetarian=None, delivery=None, open_now=False) -> List[Dict]:
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