class CreateStockSnapshots < ActiveRecord::Migration[8.1]
  def change
    create_table :stock_snapshots do |t|
      t.references :store, null: false, foreign_key: true
      t.datetime :checked_at, null: false
      t.integer :stock_level, null: false
      t.text :raw_payload

      t.index [:store_id, :checked_at]
      t.timestamps
    end
  end
end
