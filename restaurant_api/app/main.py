from fastapi import FastAPI
import uvicorn
from api.endpoints import router
from core.config import settings

def create_application() -> FastAPI:
    """Create and configure the FastAPI application"""
    application = FastAPI(
        title=settings.APP_TITLE,
        description=settings.APP_DESCRIPTION,
    )
    
    # Include the API router
    application.include_router(router)
    
    return application

app = create_application()

if __name__ == "__main__":
    uvicorn.run(
        app, 
        host=settings.HOST, 
        port=settings.PORT
    )