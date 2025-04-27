# CISO Assistant Deployment on Fly.io

## Prerequisites
- Fly.io account
- Docker (if using local builds)

## Installation
1. Install flyctl:
```bash
# Windows (PowerShell - Run as Administrator):
iwr https://fly.io/install.ps1 -useb | iex

# If you get permission errors:
1. Open PowerShell as Administrator
2. Run: Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
3. Run: iwr https://fly.io/install.ps1 -useb | iex

# Mac/Linux:
curl -L https://fly.io/install.sh | sh
```

## Deployment Steps

Note: This deployment uses Paketo buildpacks for building the application.

If you encounter build issues:
1. Try cleaning the build cache:
```bash
flyctl builds purge
```
2. Ensure Docker is running if building locally
3. Check available disk space

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

### Health Checks
The application provides a health check endpoint at `/health/` that returns:
```json
{"status": "ok"}
```

### Log Access
Application logs are streamed to stdout and can be accessed via:

```bash
# Stream live logs
flyctl logs

# Filter logs by process
flyctl logs --process app

# Show recent errors
flyctl logs | grep ERROR

# Follow logs in real-time
flyctl logs -t
```

### Verify Deployment
Check deployment status:
```bash
flyctl status
```

Verify health checks:
```bash
flyctl checks list