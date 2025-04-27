# Base stage
FROM python:3.11-slim as base

WORKDIR /app

# Backend build stage
FROM base as backend

COPY backend/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY backend .

# Frontend build stage
FROM node:18 as frontend

WORKDIR /app/frontend
COPY frontend/package.json frontend/pnpm-lock.yaml ./
RUN npm install -g pnpm && pnpm install

COPY frontend .
RUN pnpm build

# Final stage
FROM base

COPY --from=backend /app /app/backend
COPY --from=frontend /app/frontend/dist /app/frontend/dist

WORKDIR /app/backend
EXPOSE 8000

CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]