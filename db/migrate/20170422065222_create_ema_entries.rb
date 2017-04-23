class CreateEmaEntries < ActiveRecord::Migration
  def self.up
    create_table :ema_entries do |t|
      t.decimal :value
      t.string :currency
      t.integer :period
      t.timestamp :created_at
    end
  end
end
