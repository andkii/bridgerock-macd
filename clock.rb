require 'clockwork'
require 'rest_client'
require_relative 'config/boot'
require_relative 'config/environment'
require_relative 'lib/market_point_job'

include Clockwork

every(1.minutes, 'marketpoint.fetch') { Delayed::Job.enqueue MarketPointJob.new }