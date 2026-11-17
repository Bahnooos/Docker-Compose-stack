# Docker Compose Stack

A containerized full-stack application built with Node.js, Express, PostgreSQL, and Redis, exposed through an Nginx reverse proxy and orchestrated using Docker Compose.

## Overview

This project provides a multi-container environment with an API, database, cache, reverse proxy, and a Bash-based log summarizer.

The stack can be started using a single Docker Compose command.

## Features

- Node.js Express API running on port 3000
- PostgreSQL persistence using Sequelize
- Redis caching for user data
- Nginx reverse proxy exposed on port 8000
- Nginx access and error logging using a shared Docker volume
- Bash log summarizer that analyzes Nginx access logs
- HTTP status code statistics (2xx, 3xx, 4xx, and 5xx)
- Environment-based configuration using `.env`

## Project Structure

```text
docker-task/
├── .env.example
├── .gitignore
├── docker-compose.yaml
├── Dockerfile
├── index.js
├── nginx/
│   └── default.conf
├── scripts/
│   ├── Dockerfile
│   └── log-summary.sh
└── README.md
```

## Services

### App
A Node.js Express application that:
- Connects to PostgreSQL using Sequelize.
- Connects to Redis.
- Serves a homepage.
- Exposes `/health`, `/users`, and `POST /users`.

### PostgreSQL
Uses the official `postgres:17` image for persistent database storage.

### Redis
Uses Redis for caching user data.

### Nginx
Acts as a reverse proxy, forwarding incoming requests from port 8000 to the application on port 3000.

Nginx access and error logs are stored in a shared Docker volume.

### Log Summarizer
A lightweight Alpine-based container that runs a Bash script to analyze Nginx access logs.

The generated report includes:
- Total HTTP requests.
- Successful requests (2xx).
- Redirect requests (3xx).
- Client errors (4xx).
- Server errors (5xx).
- The five most recent requests.

The summary is saved to `/logs/summary.txt` in the `logs_data` Docker volume.

## Configuration

Create your local environment file from the example:

**Linux / macOS:**
```bash
cp .env.example .env
```

The `.env.example` file provides the required environment variable names and default development values.

Review the values in `.env` before starting the stack.

The actual `.env` file is excluded from Git to prevent committing local credentials.

## Getting Started

### Prerequisites
- Docker
- Docker Compose

### Start the stack

```bash
docker compose up -d --build
```

### Check services

```bash
docker compose ps
```

### Stop the stack

```bash
docker compose down
```

## Access Points

- API: http://localhost:3000
- Nginx Reverse Proxy: http://localhost:8000
- PostgreSQL: localhost:5432 (if using the default host port)
- Redis: localhost:6379

## API Endpoints

### GET /
Returns:
```text
Hello World!
```

### GET /health
Returns API health information.

### GET /users
Fetches users from Redis cache if available; otherwise retrieves them from PostgreSQL and caches the result for 10 seconds.

### POST /users
Creates a new user.

Example request body:
```json
{
  "name": "Alice",
  "age": 30
}
```

## Log Summarizer

Generate some requests through Nginx:

```bash
curl http://localhost:8000/health
curl http://localhost:8000/
curl http://localhost:8000/users
```

Run the summarizer:

```bash
docker compose run --rm log_summariser
```

View the generated report:

```bash
docker run --rm -v docker-task_logs_data:/logs alpine cat /logs/summary.txt
```

The report is stored in the persistent `logs_data` Docker volume.

### Running the Log Summarizer

The log summarizer is designed as a one-shot job, not a continuously running service.

It is not intended to remain running after Docker Compose starts the stack. After generating the summary, the container exits successfully with exit code 0.

To generate or update the report, run:

```bash
docker compose run --rm log_summariser
```

The generated report is saved to the `logs_data` Docker volume at `/logs/summary.txt`.
## Useful Commands

```bash
# View running containers
docker compose ps

# View all containers, including exited ones
docker compose ps -a

# View service logs
docker compose logs -f

# Rebuild services
docker compose up -d --build

# Run the log summarizer
docker compose run --rm log_summariser

# Stop services
docker compose down
```

## Notes

- Nginx forwards requests to the Node.js application.
- PostgreSQL data is persisted using a named Docker volume.
- Nginx logs and generated summaries use separate named Docker volumes.
- The log summarizer runs once and exits after generating its report.

## License

This project is distributed under the ISC license, as defined in `package.json`.