require 'clockwork'
require './config/boot'
require './config/environment'

module Clockwork

	every(10.seconds, 'marketpoint.fetch') { MarketPointWorker.perform_async }

end