require "sinatra"
require "redis"

set :bind, "0.0.0.0"
set :port, 8080
set :quiet, true
set :server_settings, { Silent: true }

STDERR.puts "Listening on http://localhost:8080"

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

__END__

@@ index
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Visit counter</title>
    <style>
      body { margin: 0; min-height: 100vh; display: grid; place-items: center; background: #f3f5f2; color: #26342d; font: 16px Arial, sans-serif; }
      main { width: min(100% - 48px, 360px); padding: 28px; border: 1px solid #e1e7df; border-radius: 12px; background: white; }
      h1 { margin: 0 0 12px; font-size: 26px; }
      p { color: #64736a; }
      strong { display: inline-block; padding: 10px 18px; border: 1px solid #dce9df; border-radius: 8px; background: #f3f8f4; color: #34744c; font-size: 34px; }
      .hint { margin-bottom: 0; font-size: 14px; }
    </style>
  </head>
  <body>
    <main>
      <h1>Visit counter</h1>
      <p>This page has been visited:</p>
      <strong><%= visits %></strong>
      <p class="hint">Refresh the page to increase the counter.</p>
    </main>
  </body>
</html>