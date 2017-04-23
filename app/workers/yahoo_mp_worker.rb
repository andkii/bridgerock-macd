class YahooMPWorker
	include Sidekiq::Worker
  def perform
  	
  	usdcad_points = MarketPoint.where(currency: CurrencyPair::USDCAD).length
    populate_with_historical if usdcad_points == 0
  end
  
  def populate_with_historical
    
    Rails.logger.debug "Retrieving yahooapi marketpoint..."
        
    raw = RestClient.get('https://query.yahooapis.com/v1/public/'\
                        'yql?q=SELECT%20*%20FROM%20yahoo.finance.'\
                        'historicaldata%20WHERE%20symbol%20%3D%20%22'\
                        'CAD%3DX%22%20AND%20startDate%20%3D%20%222017-03-01'\
                        '%22%20AND%20endDate%20%3D%20%222017-04-22%22&format'\
                        '=json&diagnostics=true&env=store%3A%2F%2Fdatatables'\
                        '.org%2Falltableswithkeys&callback=',
     										:accept => :json)
     										
 		data = JSON.parse raw
    data = data['query']['results']['quote']
    data.each do |d|
      date = d['Date']
      close = BigDecimal(d['Close'])
      MarketPoint.create(value: close, currency: CurrencyPair::USDCAD, created_at: date)
      update_technicals(CurrencyPair::USDCAD, close)
    end
  end
  
  def update_technicals(currency, close)
    TechnicalsHelper::updateEma(currency, close, 12)
    TechnicalsHelper::updateEma(currency, close, 26)
    TechnicalsHelper::updateMacd(currency, close, 12, 26) 
  end
end