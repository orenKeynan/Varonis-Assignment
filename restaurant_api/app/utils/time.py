from datetime import datetime
from core.logging_config import logger

def is_open(restaurant: dict) -> bool:
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