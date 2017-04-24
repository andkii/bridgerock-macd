class CreateMacdEntries < ActiveRecord::Migration
  def self.up
    create_table :macd_entries do |t|
      t.decimal :value
      t.string :currency
      t.integer :period_1
      t.integer :period_2
      t.integer :signal_period
      t.decimal :signal
      t.timestamp :created_at
    end
  end
end
