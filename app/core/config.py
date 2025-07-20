import os
from pydantic import BaseModel
from pydantic_settings import BaseSettings
from typing import List


class Settings(BaseSettings):
    # Application settings
    APP_NAME: str = "Suvidha"
    DEBUG: bool = os.getenv("DEBUG", "False").lower() in ("true", "1", "t")
    API_V1_STR: str = "/v1"
    
    # Server settings
    HOST: str = os.getenv("HOST", "localhost")
    PORT: int = int(os.getenv("PORT", "7777"))
    
    # Database settings
    DATABASE_URI: str = os.getenv('DATABASE_URI')
    
    # Logging
    LOG_LEVEL: str = os.getenv("LOG_LEVEL", "INFO")
    
    # CORS
    CORS_ORIGINS: List[str] = ["*"]
    CORS_ALLOW_CREDENTIALS: bool = True
    CORS_ALLOW_METHODS: List[str] = ["*"]
    CORS_ALLOW_HEADERS: List[str] = ["*"]
    
    class Config:
        "pydantic config"
        env_file=".env"
        extra='ignore'
        
settings = Settings()