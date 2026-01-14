class StockSnapshot < ApplicationRecord
  belongs_to :store

  validates :checked_at, presence: true
  validates :stock_level, numericality: { greater_than_or_equal_to: 0 }

  scope :recent_first, -> { order(checked_at: :desc) }
end
