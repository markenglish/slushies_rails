class Api::V1::StoresController < ApplicationController
  def index
    stores = Store.order(:name)
    render json: stores.as_json(only: [:id, :name, :store_code, :product_url, :is_active])
  end

  def show
    store = Store.find(params[:id])
    render json: store.as_json(only: [:id, :name, :store_code, :product_url, :is_active])
  end
end
