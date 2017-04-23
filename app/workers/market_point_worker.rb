require 'socket'
require 'json'

class MarketPointWorker
	include Sidekiq::Worker
	@@conn_obj = nil
	
	
	def get_connection
		return @@conn_obj if !@@conn_obj.nil?
		
		Rails.logger.debug "Creating new MarketPointWorker connection"
		
		@@conn_obj = TCPSocket.new('practice.bridgerocktech.com', 80)
		@@conn_obj.write 'login JHd0TxrtMKykqOn91fMwNqsk2Wrc5uhk2kQaTXJp2zMd1JTT'
		
		ConnectionHelper::verify_connection(@@conn_obj)
		
		return @@conn_obj
	end
	
	def perform(pair)

			@socket = get_connection
			@pair = pair
			
			Rails.logger.debug "Retrieving #{@pair} exchange rate..."
			
			@socket.write "subscribe #{@pair}"
			@quote = ConnectionHelper::expect_response(@socket)
			if !@quote
				Rails.logger.debug "#{self.class}: Terminating worker"
				return
			end
			
			@pair = @quote["pair"]
			@price = @quote["data"]["last"]
			
			@s.write "unsubscribe #{@pair}"
			
			MarketPoint.create(value: @price, currency: @pair)
	end
end
