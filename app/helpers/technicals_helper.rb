module TechnicalsHelper
	
	def self.updateEma(pair, last, period)
		
		@ema = EmaEntry.where(currency: pair, period: period).last
		
		if @ema.nil?
			initEma(pair, period)
			
		else
			Rails.logger.debug "Updating Ema"
			multiplier = 2.0/(1+period)

			new_ema = multiplier*(last - @ema.value) + @ema.value
			Rails.logger.debug "Close: #{last} Mult: #{multiplier} PrevEMA: #{@ema.value} NewEMA: #{new_ema}"
			EmaEntry.create(value: new_ema, 
											currency: pair, 
											period: period, 
											created_at: DateTime.now)
		end
			
	end
	
	def self.initEma(pair, period)
		
		Rails.logger.debug "Attempting to initialize #{pair} EMA"
		@points = MarketPoint.where(currency: pair).first(period)
		if @points.length >= period
			average = 0
			@points.each do |p|
				average += p.value
			end
			average = average/period
			Rails.logger.debug "#{period}-EMA for #{pair} has been initialized to #{average}"

			EmaEntry.create(value: average, 
											currency: pair, 
											period: period, 
											created_at: DateTime.now)
		else
			Rails.logger.debug "Not enough entries, there are #{@points.length}/#{period}"
		end
		
	end
	
	def self.initMacd(pair, period_1, period_2)
		
		#TODO check if EmaEntries are valid...
		#result = ema_1.value - ema_2.value
		#Rails.logger.debug result
	end

	def self.updateMacd(pair, last, period_1, period_2)
		
		ema_1 = EmaEntry.where(currency: pair, period: period_1).last
		ema_2 = EmaEntry.where(currency: pair, period: period_2).last
		
		if(ema_1.nil? || ema_2.nil?)
			Rails.logger.debug("Could not update #{pair} MACD on #{period_1}:#{period_2}")
		else
			macd = ema_1.value - ema_2.value
			MacdEntry.create(value: macd, 
												currency: pair, 
												period_1: period_1,
												period_2: period_2,
												created_at: DateTime.now)
		end
		
		# @macd = MacdEntry.where(currency: pair, period_1: period_1, period_2: period_2)
		
		# if @macd.nil? || @macd.empty?
		# 	initMacd(pair, period_1, period_2)
		# else
		# 	if 
		# end
		# #initMacd(pair, period_1, period_2)
	end

end