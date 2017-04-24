class MacdEntry < ApplicationRecord
  def to_s
	"#{period_1}-#{period_2}-#{signal_period} MACD #{value} Signal #{signal} at #{created_at}"
  end
end
