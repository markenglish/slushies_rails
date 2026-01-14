class WebhookEndpoint < ApplicationRecord
  has_many :webhook_deliveries, dependent: :destroy

  validates :url, presence: true
  scope :active, -> { where(is_active: true) }
end
