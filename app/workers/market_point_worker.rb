#MarketPointWorker class
#Worker for grabbing market point data from the Bridgerock practice server

require 'socket'
require 'json'

class MarketPointWorker
	include Sidekiq::Worker
	sidekiq_options :retry => false
	@@conn_obj = nil
	
	#Returns an existing connection to the Bridgerock practice server or
	#creates a new one if it does not exist
	def get_connection
		return @@conn_obj if !@@conn_obj.nil?
		
		Rails.logger.debug "Creating new MarketPointWorker connection"
		
		@@conn_obj = TCPSocket.new('practice.bridgerocktech.com', 80)
		@@conn_obj.write 'login JHd0TxrtMKykqOn91fMwNqsk2Wrc5uhk2kQaTXJp2zMd1JTT'
		
		ConnectionHelper::verify_connection(@@conn_obj)
		
		return @@conn_obj
	end
	
	#Get the connection and subscribe to a currency pair
	#Create a new market data point and update technicals
	def perform(pair)

			socket = get_connection
			
			Rails.logger.debug "Retrieving #{pair} exchange rate..."
			
			socket.write "subscribe #{pair}"
			quote = ConnectionHelper::expect_response(socket)
			socket.write "unsubscribe #{pair}"
			if !quote
				Rails.logger.debug "#{self.class}: Terminating worker"
				return
			end
			
			quote = quote["quote"]
			price = quote["data"]["last"]
			
			if quote["pair"] != pair
				Rails.logger.debug "Quote mismatch! Expected #{pair}, got #{quote["pair"]}"
			else
				MarketPoint.create(value: price, currency: pair)
				TechnicalsHelper::update_all_technicals(pair, price)
			end
			
	end
	
end