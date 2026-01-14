# frozen_string_literal: true

class StockRecorder
  def self.record!(store:, scrape_result:)
    raise ArgumentError, "scrape_result not ok" unless scrape_result.ok

    prev = store.stock_snapshots.recent_first.limit(1).first
    prev_level = prev&.stock_level.to_i

    snapshot = store.stock_snapshots.create!(
      checked_at: scrape_result.checked_at,
      stock_level: scrape_result.stock_level,
      raw_payload: scrape_result.raw.to_json
    )

    in_stock_now = snapshot.stock_level > 0
    was_out_of_stock = prev_level <= 0

    if in_stock_now && was_out_of_stock
      WebhookEndpoint.active.find_each do |endpoint|
        delivery = WebhookDelivery.create!(
          webhook_endpoint: endpoint,
          store: store,
          stock_snapshot: snapshot,
          event_type: "stock.in_stock",
          status: "pending",
          attempts: 0
        )
        DeliverWebhookJob.perform_later(delivery.id)
      end
    end

    snapshot
  end
end
