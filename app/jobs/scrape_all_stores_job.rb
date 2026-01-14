class ScrapeAllStoresJob < ApplicationJob
  queue_as :default

  def perform
    Store.active.find_each do |store|
      ScrapeStoreJob.perform_later(store.id)
    end
  end
end
