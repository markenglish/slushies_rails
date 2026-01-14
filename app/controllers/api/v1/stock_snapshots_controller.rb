class Api::V1::StockSnapshotsController < ApplicationController
  def index
    store = Store.find(params[:store_id])

    scope = store.stock_snapshots

    if params[:from].present?
      scope = scope.where("checked_at >= ?", Time.iso8601(params[:from]))
    end

    if params[:to].present?
      scope = scope.where("checked_at <= ?", Time.iso8601(params[:to]))
    end

    if params[:in_stock].present? && params[:in_stock].to_s == "true"
      scope = scope.where("stock_level > 0")
    end

    limit = [params.fetch(:limit, 500).to_i, 2000].min
    scope = scope.order(checked_at: :asc).limit(limit)

    render json: scope.as_json(only: [:id, :checked_at, :stock_level])
  end
end
