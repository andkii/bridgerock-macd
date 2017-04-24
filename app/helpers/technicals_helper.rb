module TechnicalsHelper
	
	def self.update_all_technicals(currency, close)
  	updateEma(currency, close, 12)
  	updateEma(currency, close, 26)
  	updateMacd(currency, close, 12, 26) 
  	updateMacdSignal(currency, 12, 26, 9)
	end
	
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
			average = 0.0
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
	end

	def self.updateMacdSignal(pair, period_1, period_2, signal_period)
		
		@macd_last_with_signal = MacdEntry.where(currency: pair, 
														period_1: period_1, 
														period_2: period_2, 
														signal_period: signal_period).last
														
		@macd = MacdEntry.where(currency: pair,
														period_1: period_1,
														period_2: period_2,
														signal_period: [false, nil]).last
														
		Rails.logger.debug "Updating MACD signal"
		
		if @macd_last_with_signal.nil?
			initMacdSignal(pair, period_1, period_2, signal_period)
		elsif @macd_last_with_signal.created_at > @macd.created_at	
			Rails.logger.debug "#{self.class}: Something isn't right... check the latest MACD entries in DB."
		else
			multiplier = 2.0/(1+signal_period)
			new_signal = multiplier*(@macd.value - @macd_last_with_signal.signal) + @macd_last_with_signal.signal
			
			@macd.update(currency: pair, 
									signal_period: signal_period, 
									signal: new_signal,
									created_at: DateTime.now)
		end
	end
	
	def self.initMacdSignal(pair, period_1, period_2, signal_period)
		@macd = MacdEntry.where(currency: pair, 
														period_1: period_1, 
														period_2: period_2).last(signal_period)
														
		if @macd.length >= signal_period
			average = 0.0
			@macd.each do |p|
				average += p.value
			end
			average = average/signal_period
			
			Rails.logger.debug "#{signal_period}-MACD Signal for #{pair} has been initialized to #{average}"

			@macd.last.update(signal_period: signal_period,
												signal: average,
												created_at: DateTime.now)
		else
			Rails.logger.debug "Not enough MACD entries to calculate signal, there are #{@macd.length}/#{signal_period}"
		end
	end

end