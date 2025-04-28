import os
from pydantic import BaseSettings

class Settings(BaseSettings):
    # Application settings
    APP_TITLE: str = "Restaurant Recommendation API"
    APP_DESCRIPTION: str = "API for querying and recommending restaurants based on various criteria"
    HOST: str = os.environ.get("HOST", "0.0.0.0")
    PORT: int = int(os.environ.get("PORT", 8000))
    
    # Database settings
    DB_SERVER: str = os.environ.get("DB_SERVER", "localhost")
    DB_NAME: str = os.environ.get("DB_NAME", "restaurant_db")
    DB_USERNAME: str = os.environ.get("DB_USERNAME", "")
    DB_PASSWORD: str = os.environ.get("DB_PASSWORD", "")
    CONN_TIMEOUT: int = int(os.environ.get("CONN_TIMEOUT", 30))
    ENCRYPT: str = os.environ.get("ENCRYPT", "yes")
    MAX_POOL_SIZE: int = int(os.environ.get("MAX_POOL_SIZE", 10))
    
    class Config:
        env_file = ".env"

settings = Settings()