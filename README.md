# Sinatra + Redis

A small Sinatra app that demonstrates Docker Compose with two services. The visit counter is stored in Redis and persists across container restarts.

## Services

- `app` — Sinatra and Puma, available at [http://localhost:8080](http://localhost:8080)
- `redis` — Redis 7, stores the counter in the `redis-data` Docker volume

Compose starts `app` after Redis passes its health check. Both services are connected to the `app-network` network.
Both services have health checks: Redis is checked with `redis-cli ping`, and the app is checked through `/health`.

## Project structure

```
.
├── app.rb                 # Sinatra routes
├── compose.yaml           # services, network, and volume
├── Dockerfile
├── Gemfile
└── README.md
```

The small page and its styles are kept in Sinatra's inline template in `app.rb`.

## Run

```bash
docker compose up -d --build
```

Open [http://localhost:8080](http://localhost:8080). Each page refresh increments the counter.

## Verify

```bash
docker compose config
docker compose ps
curl -i http://localhost:8080
curl http://localhost:8080/health
docker compose logs
docker inspect --format='{{json .State.Health}}' $(docker compose ps -q app)
docker compose down
```

Remove the data volume separately with `docker compose down -v`.

## Run without Docker

Start Redis locally, then run the app with its host set to localhost:

```bash
bundle install
REDIS_HOST=127.0.0.1 REDIS_PORT=6379 bundle exec ruby app.rb
```
