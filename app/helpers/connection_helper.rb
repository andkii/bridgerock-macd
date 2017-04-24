#ConnectionHelper
#Helper module for socket communication 

module ConnectionHelper 
	
	#Verify that the connection was created succesfully
	
	def self.verify_connection(socket)
		result = expect_response(socket)
		if !result
			return false
		elsif result[:connected] == "true"
			Rails.logger.debug "Connection successful"
			return true
		end
	end

	#Expect a response on the socket and parse to JSON
	#Waits for 13 seconds before timing out

	def self.expect_response(socket)
		ready = IO.select([socket], nil, nil, 13)
		if ready
		    return JSON.parse(socket.gets)
		else
			Rails.logger.debug "Response timed out..."
		    return false
		end
	end
	
end