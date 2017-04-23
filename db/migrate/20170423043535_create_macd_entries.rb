class CreateMacdEntries < ActiveRecord::Migration[5.0]
  def change
    create_table :macd_entries do |t|
      t.decimal :value
      t.string :currency
      t.integer :period_1
      t.integer :period_2
      t.timestamp :created_at
    end
  end
end
