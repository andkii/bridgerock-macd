class MarketPointJob
  def perform
    # raw = RestClient.get('http://www.google.com/finance/info?client=ig&q=INDEXDJX:.DJI', :accept => :json)
    # data = JSON.parse raw.gsub(%r{^//}, '')
    # MarketPoint.create(value: data.first['l'])
    require 'socket'
    require 'json'
     
    @@s = TCPSocket.new 'practice.bridgerocktech.com', 80
     
    @@s.write 'login JHd0TxrtMKykqOn91fMwNqsk2Wrc5uhk2kQaTXJp2zMd1JTT'
    @response = JSON.parse(@@s.gets)
    
    @@s.write 'subscribe USD-CAD'
    @quote = JSON.parse(@@s.gets)["quote"]
    @pair = @quote["pair"]
    @price = @quote["data"]["last"]
    
    MarketPoint.create(value: @price, currency: @pair)
  end
end
