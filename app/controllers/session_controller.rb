class SessionController < ApplicationController

	def index

		@eurusd_points = MarketPoint.where(currency: CurrencyPair::EURUSD)
																.order(created_at: :desc)
																
		@usdcad_points = MarketPoint.where(currency: CurrencyPair::USDCAD)
																.order(created_at: :desc)
																
		@usdjpy_points = MarketPoint.where(currency: CurrencyPair::USDJPY)
																.order(created_at: :desc)
																
		@audusd_points = MarketPoint.where(currency: CurrencyPair::AUDUSD)
																.order(created_at: :desc)

		@usdcad_ema12 = EmaEntry.where(currency: CurrencyPair::USDCAD, period: 12).last
		@usdcad_ema26 = EmaEntry.where(currency: CurrencyPair::USDCAD, period: 26).last
	end

end
