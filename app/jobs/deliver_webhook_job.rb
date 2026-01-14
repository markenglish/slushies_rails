require "openssl"

class DeliverWebhookJob < ApplicationJob
  queue_as :default

  MAX_ATTEMPTS = 8

  def perform(delivery_id)
    delivery = WebhookDelivery.find(delivery_id)
    return unless delivery.status == "pending"

    endpoint = delivery.webhook_endpoint
    snapshot = delivery.stock_snapshot
    store = delivery.store

    payload = {
      event: delivery.event_type,
      store: { id: store.id, code: store.store_code, name: store.name },
      stock: { level: snapshot.stock_level, checked_at: snapshot.checked_at.iso8601 }
    }

    body = JSON.generate(payload)
    signature = sign(endpoint.secret.to_s, body)

    resp = Faraday.post(endpoint.url) do |req|
      req.headers["Content-Type"] = "application/json"
      req.headers["X-Signature"] = signature if endpoint.secret.present?
      req.body = body
      req.options.timeout = 10
      req.options.open_timeout = 5
    end

    if resp.status >= 200 && resp.status < 300
      delivery.update!(status: "success", attempts: delivery.attempts + 1, last_error: nil)
    else
      fail_delivery!(delivery, "HTTP #{resp.status}: #{resp.body.to_s[0, 500]}")
    end
  rescue => e
    delivery = WebhookDelivery.find_by(id: delivery_id)
    fail_delivery!(delivery, "#{e.class}: #{e.message}") if delivery
  end

  private

  def sign(secret, body)
    OpenSSL::HMAC.hexdigest("SHA256", secret, body)
  end

  def fail_delivery!(delivery, err)
    delivery.update!(
      attempts: delivery.attempts + 1,
      last_error: err,
      status: (delivery.attempts + 1 >= MAX_ATTEMPTS) ? "failed" : "pending"
    )

    if delivery.status == "pending"
      # basic backoff: 2^attempt minutes
      delay = (2**[delivery.attempts, 10].min).minutes
      DeliverWebhookJob.set(wait: delay).perform_later(delivery.id)
    end
  end
end
