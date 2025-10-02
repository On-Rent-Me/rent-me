# Ruby buildpack sets RAILS_ENV and RACK_ENV in production.
run_env = ENV["RAILS_ENV"] || ENV["RACK_ENV"] || "development"
environment(run_env)

# Thread per process count allows context switching on IO-bound tasks for better CPU utilization.
threads_count = ENV.fetch("RAILS_MAX_THREADS") { 3 }
threads(threads_count, threads_count)

# Processes count, allows better CPU utilization when executing Ruby code.
# Set to 0 for development on macOS to avoid fork issues with objc runtime
worker_count = run_env == "development" ? 0 : ENV.fetch("WEB_CONCURRENCY") { 2 }
workers(worker_count)

# Reduce memory usage on copy-on-write (CoW) systems.
preload_app! if worker_count > 0

# Support IPv6 by binding to host `::` in production instead of `0.0.0.0` and `::1` instead of `127.0.0.1` in development.
host = run_env == "production" ? "::" : "::1"

# PORT environment variable is set by Heroku in production.
port(ENV.fetch("PORT") { 3000 }, host)

# Allow Puma to be restarted by the `rails restart` command locally.
plugin(:tmp_restart)

# Heroku strongly recommends upgrading to Puma 7+. If you cannot upgrade,
# please see the Puma 6 and prior configuration section below.
#
# Puma 7+ already supports PUMA_PERSISTENT_TIMEOUT natively. Older Puma versions set:
#
# ```
# persistent_timeout(ENV.fetch("PUMA_PERSISTENT_TIMEOUT") { 95 }.to_i)
# ```
#
# Puma 7+ fixes a keepalive issue that affects long tail response time with Router 2.0.
# Older Puma versions set:
#
# ```
# enable_keep_alives(false) if respond_to?(:enable_keep_alives)
# ```
