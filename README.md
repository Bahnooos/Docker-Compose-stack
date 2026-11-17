# Docker Compose Stack

A containerized full-stack stack for a Node.js API backed by PostgreSQL and Redis, exposed through Nginx and orchestrated with Docker Compose.

## Overview

This project bundles the following services:

- Node.js app with Express
- PostgreSQL database
- Redis cache
- Nginx reverse proxy
- Log summarizer container for Docker logs

It is designed to run locally with a single Docker Compose command and provides a simple API for user management.

## Features

- Express API running on port 3000
- PostgreSQL persistence with Sequelize
- Redis-based cached user list
- Nginx listening on port 8000 and forwarding requests to the app
- Dockerized log summarizer service
- Environment-based configuration via `.env`

## Project Structure

```text
.
├── .dockerignore
├── .env
├── Dockerfile
├── docker-compose.yaml
├── index.js
├── nginx/
│   └── default.conf
├── package.json
├── package-lock.json
├── scripts/
│   ├── Dockerfile
│   └── log-summary.sh
└── README.md
```

## Services

### App

The main application is a Node.js Express service that:

- connects to PostgreSQL using Sequelize
- connects to Redis
- serves a simple homepage
- exposes `/health`, `/users`, and `POST /users`

### PostgreSQL

Runs the official `postgres:17` image.

### Redis

Runs the official `redis:latest` image.

### Nginx

Acts as a reverse proxy and exposes the app on port `8000`.

### Log Summarizer

Runs a small script-based container that reads Docker logs and produces summaries for the stack.

## Configuration

### Environment Setup

Before starting the application, create your local environment file from the example:

**Linux:**
```
cp .env.example .env
```

The `.env.example` file contains the required development configuration. Update the values if needed.

The actual `.env` file is excluded from Git to avoid committing local environment credentials.

Start the application:


You can customize these values as needed before starting the stack.

## Getting Started

### Prerequisites

- Docker
- Docker Compose

### Start the stack

```bash
docker compose up --build
```

### Stop the stack

```bash
docker compose down
```

## Access Points

- App: http://localhost:3000
- Nginx: http://localhost:8000
- PostgreSQL: localhost:5432
- Redis: localhost:6379

## API Endpoints

### GET /

Returns:

```text
Hello World!
```

### GET /health

Returns service health information.

### GET /users

Fetches users from Redis cache if available; otherwise loads them from PostgreSQL and stores them in Redis for 10 seconds.

### POST /users

Creates a new user record.

Example request body:

```json
{
  "name": "Alice",
  "age": 30
}
```

## Useful Commands

```bash
# View running containers
docker compose ps

# View logs
docker compose logs -f

# Rebuild after changes
docker compose up --build
```

## Notes

- The app container exposes port `3000` internally.
- Nginx routes traffic from port `8000` to the Node.js app.
- Persistent storage is configured for PostgreSQL and logs data using Docker volumes.

## License

This project is distributed under the ISC license, as defined in `package.json`.
