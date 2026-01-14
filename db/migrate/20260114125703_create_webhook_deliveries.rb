class CreateWebhookDeliveries < ActiveRecord::Migration[8.1]
  def change
    create_table :webhook_deliveries do |t|
      t.references :webhook_endpoint, null: false, foreign_key: true
      t.references :store, null: false, foreign_key: true
      t.references :stock_snapshot, null: false, foreign_key: true
      t.string :event_type, null: false
      t.string :status, null: false, default: "pending"
      t.integer :attempts, null: false, default: 0
      t.text :last_error
      t.index [:webhook_endpoint_id, :store_id, :stock_snapshot_id], name: "idx_webhook_uniqueness"
      t.timestamps
    end
  end
end
