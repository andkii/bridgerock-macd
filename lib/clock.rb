require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork

	every(1.minutes, 'marketpoint.fetch') { Resque.enqueue(MarketPointWorker, CurrencyPair::AUDUSD) }
	every(1.minutes, 'marketpoint.fetch') { Resque.enqueue(MarketPointWorker, CurrencyPair::USDCAD) }
	every(1.minutes, 'marketpoint.fetch') { Resque.enqueue(MarketPointWorker, CurrencyPair::USDJPY) }
	every(1.minutes, 'marketpoint.fetch') { Resque.enqueue(MarketPointWorker, CurrencyPair::EURUSD) }
	
end