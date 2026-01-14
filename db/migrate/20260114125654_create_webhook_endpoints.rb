class CreateWebhookEndpoints < ActiveRecord::Migration[8.1]
  def change
    create_table :webhook_endpoints do |t|
      t.string :url, null: false
      t.string :secret
      t.boolean :is_active, null: false, default: true

      t.timestamps
    end
  end
end
