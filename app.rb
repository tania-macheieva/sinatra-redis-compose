require "sinatra"
require "redis"

set :bind, "0.0.0.0"
set :port, 8080

REDIS = Redis.new(
  host: ENV.fetch("REDIS_HOST", "redis"),
  port: ENV.fetch("REDIS_PORT", "6379").to_i
)

get "/" do
  erb :index, locals: { visits: REDIS.incr("hits") }
end

get "/health" do
  REDIS.ping == "PONG" ? "OK\n" : halt(500, "Redis is unavailable\n")
end