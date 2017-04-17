require 'clockwork'
require 'rest_client'
require './config/boot'
require './config/environment'

module Clockwork

	every(10.seconds, 'marketpoint.fetch') { Delayed::Job.enqueue MarketPointJob.new }

end