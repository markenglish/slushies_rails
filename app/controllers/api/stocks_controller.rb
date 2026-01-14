class Api::V1::StocksController < ApplicationController
  def latest
    # SQLite-friendly "latest per store" approach:
    # 1) get last snapshot id per store by checked_at
    stores = Store.order(:name).includes(:stock_snapshots)

    data = stores.map do |s|
      snap = s.stock_snapshots.order(checked_at: :desc).first
      {
        store: { id: s.id, code: s.store_code, name: s.name },
        latest: snap ? { stock_level: snap.stock_level, checked_at: snap.checked_at } : nil
      }
    end

    render json: data
  end
end
