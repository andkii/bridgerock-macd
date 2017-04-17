class CreateMarketPoints < ActiveRecord::Migration
  def self.up
    create_table :market_points do |t|
      t.decimal :value
      t.string  :currency
      t.timestamp :created_at
    end
  end
end