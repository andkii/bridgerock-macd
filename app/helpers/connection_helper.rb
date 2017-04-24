module ConnectionHelper 
	
	def self.verify_connection(socket)
		
		result = expect_response(socket)
		if !result
			return false
		elsif result[:connected] == "true"
			Rails.logger.debug "Connection successful"
			return true
		end
		
	end

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