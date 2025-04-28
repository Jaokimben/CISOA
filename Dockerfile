# Root Dockerfile for Fly.io deployment
FROM python:3.12-slim

WORKDIR /code

# Copy backend files
COPY backend/pyproject.toml backend/poetry.lock ./

# Install dependencies
RUN pip install poetry==2.0.1 && \
    poetry install --no-root

# Copy rest of backend
COPY backend/ .

EXPOSE 8080
ENTRYPOINT ["poetry", "run", "bash", "startup.sh"]