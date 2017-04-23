class EmaEntry < ActiveRecord::Base
	def to_s
		"#{period}-EMA for #{currency} is #{value} at #{created_at}"
	end

end
