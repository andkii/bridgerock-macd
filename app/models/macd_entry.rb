class MacdEntry < ApplicationRecord
	  def to_s
    "MACD #{currency} #{value} at #{created_at}"
  end
end
