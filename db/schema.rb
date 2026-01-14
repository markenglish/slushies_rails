# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_14_125703) do
  create_table "stock_snapshots", force: :cascade do |t|
    t.datetime "checked_at"
    t.datetime "created_at", null: false
    t.text "raw_payload"
    t.integer "stock_level"
    t.integer "store_id", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_stock_snapshots_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active"
    t.string "name"
    t.string "product_url"
    t.text "scrape_profile"
    t.string "store_code"
    t.datetime "updated_at", null: false
  end

  create_table "webhook_deliveries", force: :cascade do |t|
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "event_type", null: false
    t.text "last_error"
    t.string "status", default: "pending", null: false
    t.integer "stock_snapshot_id", null: false
    t.integer "store_id", null: false
    t.datetime "updated_at", null: false
    t.integer "webhook_endpoint_id", null: false
    t.index ["stock_snapshot_id"], name: "index_webhook_deliveries_on_stock_snapshot_id"
    t.index ["store_id"], name: "index_webhook_deliveries_on_store_id"
    t.index ["webhook_endpoint_id", "store_id", "stock_snapshot_id"], name: "idx_webhook_uniqueness"
    t.index ["webhook_endpoint_id"], name: "index_webhook_deliveries_on_webhook_endpoint_id"
  end

  create_table "webhook_endpoints", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.boolean "is_active"
    t.string "secret"
    t.datetime "updated_at", null: false
    t.string "url"
  end

  add_foreign_key "stock_snapshots", "stores"
  add_foreign_key "webhook_deliveries", "stock_snapshots"
  add_foreign_key "webhook_deliveries", "stores"
  add_foreign_key "webhook_deliveries", "webhook_endpoints"
end
