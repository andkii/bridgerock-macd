class SessionController < ApplicationController
	
  def start
    require 'socket'
    require 'json'
     
    @@s = TCPSocket.new 'practice.bridgerocktech.com', 80
     
    @@s.write 'login JHd0TxrtMKykqOn91fMwNqsk2Wrc5uhk2kQaTXJp2zMd1JTT'
    @response = JSON.parse(@@s.gets)

    @@s.write 'subscribe USD-CAD'
    @response = JSON.parse(@@s.gets)
    
  end

	def index
    @points = MarketPoint.all.order(created_at: :desc)
  end
	
end
