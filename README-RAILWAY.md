# Railway Deployment Guide

## Prerequisites
- GitHub account
- Railway account connected to GitHub
- PostgreSQL database

## Setup Steps

1. **Connect your repository**:
   - Log in to Railway
   - Click "New Project" and select "Deploy from GitHub repo"
   - Select your CISO Assistant repository

2. **Configure environment variables**:
   - Go to your project's "Variables" tab
   - Add all variables from `.env.sample`
   - Generate a secure `SECRET_KEY`
   - Add your `DATABASE_URL` (will be auto-provided if using Railway PostgreSQL)

3. **Deploy**:
   - Railway will automatically detect and use the `Procfile` and `railway.json`
   - The first deploy will run migrations automatically

4. **Post-deployment**:
   - Create a superuser: `railway run python manage.py createsuperuser`
   - Access admin panel at `/admin`

## Database Setup
Railway will automatically provision a PostgreSQL database. The connection URL will be available as `DATABASE_URL` environment variable.

## Custom Domains
You can configure a custom domain in Railway's "Settings" tab after deployment.