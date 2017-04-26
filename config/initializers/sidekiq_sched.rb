Sidekiq.redis { |conn| conn.flushdb }

Sidekiq.configure_server do |config|
  config.average_scheduled_poll_interval = 5
end
Sidekiq.options[:poll_interval] = 5