# SARV SUVIDHA

## Project Overview
Sarv Suvidha is a FastAPI-based web service providing various API endpoints. The project is structured with modular components including API routes, core configurations, database connections, and models.

## Installation and Setup

### Prerequisites
- Python 3.8 or higher
- PostgreSQL database (or configured database as per settings)
- pip (Python package installer)

### Install Dependencies
It is recommended to use a virtual environment:

```bash
python -m venv venv
source venv/Scripts/activate  # On Windows
# or
source venv/bin/activate      # On Unix or MacOS
```

Then install the required packages:

```bash
pip install -r requirements.txt
```

### Configuration
The application settings are managed in `app/core/config.py`. Ensure you configure the following environment variables or settings accordingly:

- `APP_NAME` - Application name
- `DEBUG` - Enable or disable debug mode
- `HOST` - Host address to run the server (e.g., 127.0.0.1)
- `PORT` - Port number to run the server (e.g., 8000)
- `CORS_ORIGINS` - Allowed CORS origins
- Database connection settings in `app/core/database.py`

### Running the Application
To start the FastAPI server, run the following command:

```bash
python run.py
```

This will start the server using Uvicorn. You should see output similar to:

```
Starting server at http://<HOST>:<PORT>
Documentation available at http://<HOST>:<PORT>/docs
```

You can access the API documentation at `/docs` endpoint.

## Project Structure

```
app/
├── api/           # API route definitions
├── core/          # Core configurations, logging, and database connection
├── models.py      # Database models
├── schema.py      # Pydantic schemas for request/response validation
run.py             # Application entry point
README.MD          # This file
.gitignore         # Git ignore rules
requirements.txt   # Python dependencies
```

## Additional Notes
- The application uses asynchronous lifespan events to manage database connections.
- CORS middleware is configured to allow cross-origin requests based on settings.
- Logging is set up in `app/core/logging.py` to capture application logs.

## Git Ignore
The `.gitignore` file excludes:

```
__pycache__/
.env
.venv
```

Make sure to add any sensitive files or environment variables to `.env` and keep it out of version control.

---

