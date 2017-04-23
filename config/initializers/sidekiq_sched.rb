Sidekiq.redis { |conn| conn.flushdb }

# Sidekiq::Cron::Job.create(name: 'MarketPointWorker job', 
# 													cron: '*/1 * * * *', 
# 													class: 'MarketPointWorker', 
# 													args: CurrencyPair::USDCAD)
													
Sidekiq::Cron::Job.create(name: 'YahooMPWorker job', 
													cron: '*/1 * * * *', 
													class: 'YahooMPWorker')
													