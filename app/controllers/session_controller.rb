class SessionController < ApplicationController

	def index
		@eurusd_points = MarketPoint.where(currency: CurrencyPair::EURUSD).order(created_at: :desc).first(12)
		@usdcad_points = MarketPoint.where(currency: CurrencyPair::USDCAD).order(created_at: :desc).first(12)
		@usdjpy_points = MarketPoint.where(currency: CurrencyPair::USDJPY).order(created_at: :desc).first(12)
		@audusd_points = MarketPoint.where(currency: CurrencyPair::AUDUSD).order(created_at: :desc).first(12)

		@usdcad_ema12 = EmaEntry.where(currency: CurrencyPair::USDCAD, period: 12).last
		@usdcad_ema26 = EmaEntry.where(currency: CurrencyPair::USDCAD, period: 26).last
		@usdcad_macd	= MacdEntry.where(currency: CurrencyPair::USDCAD, period_1: 12, period_2: 26).last
		
		@usdjpy_ema12 = EmaEntry.where(currency: CurrencyPair::USDJPY, period: 12).last
		@usdjpy_ema26 = EmaEntry.where(currency: CurrencyPair::USDJPY, period: 26).last
		@usdjpy_macd	= MacdEntry.where(currency: CurrencyPair::USDJPY, period_1: 12, period_2: 26).last
		
		@eurusd_ema12 = EmaEntry.where(currency: CurrencyPair::EURUSD, period: 12).last
		@eurusd_ema26 = EmaEntry.where(currency: CurrencyPair::EURUSD, period: 26).last
		@eurusd_macd	= MacdEntry.where(currency: CurrencyPair::EURUSD, period_1: 12, period_2: 26).last
		
		@audusd_ema12 = EmaEntry.where(currency: CurrencyPair::AUDUSD, period: 12).last
		@audusd_ema26 = EmaEntry.where(currency: CurrencyPair::AUDUSD, period: 26).last
		@audusd_macd	= MacdEntry.where(currency: CurrencyPair::AUDUSD, period_1: 12, period_2: 26).last
	end
	
	def get_macd
		currency = params[:currency].upcase
		
		if currency.nil?
			response = {:error => "expected a currency in the form of {from}-{to}"}
			render json: response, content_type: 'application/json'
			return
		end

		valid_currency = false
		CurrencyPair.constants.each do |c|
	  	if currency == CurrencyPair.const_get(c)
	  		valid_currency = true
	  		break
	  	end
		end
		
		if valid_currency
			macd = MacdEntry.where(currency: currency, period_1: 12, period_2: 26, signal_period: 9).last
			if macd.nil?
				response = {:error => "#{currency} MACD is not available"}
				render json: response, content_type: 'application/json'
			else
				render json: macd, content_type: 'application/json'	
			end
		else
			response = {:error => "#{currency} is not a valid currency"}
			render json: response, content_type: 'application/json'
		end
	end

end
