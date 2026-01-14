class Store < ApplicationRecord
  has_many :stock_snapshots, dependent: :destroy
  has_many :webhook_deliveries, dependent: :destroy

  validates :name, presence: true
  validates :store_code, presence: true, uniqueness: true
  validates :product_url, presence: true

  scope :active, -> { where(is_active: true) }

  def scrape_profile_hash
    return {} if scrape_profile.blank?
    JSON.parse(scrape_profile)
  rescue JSON::ParserError
    {}
  end
end
