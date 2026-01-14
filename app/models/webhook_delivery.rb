class WebhookDelivery < ApplicationRecord
  belongs_to :webhook_endpoint
  belongs_to :store
  belongs_to :stock_snapshot

  validates :event_type, presence: true
  validates :status, presence: true
end
