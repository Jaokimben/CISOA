# CISO Assistant Deployment on Fly.io

## Prerequisites
- Fly.io account
- Docker (if using local builds)

## Installation
1. Install flyctl:
```bash
# Windows (PowerShell):
iwr https://fly.io/install.ps1 -useb | iex

# Mac/Linux:
curl -L https://fly.io/install.sh | sh
```

## Deployment Steps

Note: This deployment uses Docker for building the application.

1. Create the Fly.io application:
```bash
flyctl launch --name ciso-assistant --region ams --now
```

2. Create and attach a PostgreSQL database:
```bash
flyctl postgres create --name ciso-assistant-db --region ams --vm-size shared-cpu-1x --initial-cluster-size 1
flyctl postgres attach ciso-assistant-db
```

3. Set required environment variables:
```bash
flyctl secrets set SECRET_KEY=$(python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())')
```

4. Deploy the application:
```bash
flyctl deploy
```

## Environment Variables
- `DATABASE_URL`: Automatically set by postgres attach
- `SECRET_KEY`: Django secret key (set during deployment)
- `DEBUG`: Set to "False" in production
- `ALLOWED_HOSTS`: Set to "*" or your domain
- `DISABLE_COLLECTSTATIC`: Set to "1" if not using static files

## Scaling
To scale the application:
```bash
flyctl scale count 2  # Scale to 2 instances
```

## Monitoring
View logs:
```bash
flyctl logs