class MarketPoint < ActiveRecord::Base
  def to_s
    "#{currency} #{value} at #{created_at}"
  end
end
