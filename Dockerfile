# Production Dockerfile
FROM python:3.12-slim

# Install system dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libgirepository1.0-dev \
    libcairo2-dev \
    libpango1.0-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /code

# Copy backend files
COPY backend/pyproject.toml backend/poetry.lock ./

# Install Python dependencies
RUN pip install poetry==2.0.1 && \
    poetry install --no-root --only main

# Copy rest of backend
COPY backend/ .

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD poetry run python manage.py check_db_connection

EXPOSE 8080
ENTRYPOINT ["poetry", "run", "bash", "startup.sh"]