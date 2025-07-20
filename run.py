import uvicorn
from fastapi import FastAPI
from app.api.routes import api_router
from fastapi.middleware.cors import CORSMiddleware
from app.core.config import settings
from app.core.logging import logger
from contextlib import asynccontextmanager
from app.core.database import postgres_db


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Handle startup and shutdown events."""
    # Startup
    logger.info("Initializing database connection...")
    await postgres_db.connect()
    yield
    logger.info("closing the database connection")
    await postgres_db.close()


app = FastAPI(
    title=settings.APP_NAME,
    debug=settings.DEBUG,
    lifespan=lifespan
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=settings.CORS_ALLOW_CREDENTIALS,
    allow_methods=settings.CORS_ALLOW_METHODS,
    allow_headers=settings.CORS_ALLOW_HEADERS,
)

app.include_router(api_router, prefix='/api')

@app.get("/")
async def root():
    """Root endpoint."""
    return {"message": "Welcome to sarv suvidha API"}


if __name__=="__main__":
    """Run the application with uvicorn server."""
    print(f"Starting server at http://{settings.HOST}:{settings.PORT}")
    print(f"Documentation available at http://{settings.HOST}:{settings.PORT}/docs")
    
    uvicorn.run(
        'run:app',
        host=settings.HOST,
        port=settings.PORT,
        reload=settings.DEBUG
    )