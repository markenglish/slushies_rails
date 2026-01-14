class CreateStores < ActiveRecord::Migration[8.1]
  def change
    create_table :stores do |t|
      t.string :name
      t.string :store_code, null: false
      t.string :product_url
      t.boolean :is_active, null: false, default: true
      t.text :scrape_profile
      t.index :store_code, unique: true

      t.timestamps
    end
  end
end
