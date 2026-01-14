class ScrapeStoreJob < ApplicationJob
  queue_as :default

  def perform(store_id)
    store = Store.find(store_id)
    result = Scrapers::PlaywrightScraper.fetch(store)

    return unless result.ok

    StockRecorder.record!(store: store, scrape_result: result)
  rescue => e
    Rails.logger.error("ScrapeStoreJob store_id=#{store_id} error=#{e.class} #{e.message}")
  end
end
