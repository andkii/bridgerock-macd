Sidekiq.redis { |conn| conn.flushdb }

Sidekiq.configure_server do |config|
  config.average_scheduled_poll_interval = 5
end
Sidekiq.options[:poll_interval] = 5

# Sidekiq::Cron::Job.create(name: 'MarketPointWorker job', 
# 													cron: '*/1 * * * *', 
# 													class: 'MarketPointWorker', 
# 													args: CurrencyPair::USDCAD)
													
# Sidekiq::Cron::Job.create(name: 'MarketPointWorker job USDCAD', 
# 													cron: '*/1 * * * *', 
# 													class: 'MarketPointWorker',
# 													args: [CurrencyPair::USDCAD])

# Sidekiq::Cron::Job.create(name: 'MarketPointWorker job USDJPY', 
# 													cron: '*/1 * * * *', 
# 													class: 'MarketPointWorker',
# 													args: [CurrencyPair::USDJPY])
													
# Sidekiq::Cron::Job.create(name: 'MarketPointWorker job EURUSD', 
# 													cron: '*/1 * * * *', 
# 													class: 'MarketPointWorker',
# 													args: [CurrencyPair::EURUSD])

# Sidekiq::Cron::Job.create(name: 'MarketPointWorker job AUDUSD', 
# 													cron: '*/1 * * * *', 
# 													class: 'MarketPointWorker',
# 													args: [CurrencyPair::AUDUSD])
													