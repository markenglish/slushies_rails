require "sidekiq"
require "sidekiq-cron"

Sidekiq.configure_server do |config|
  schedule_file = Rails.root.join("config", "sidekiq.yml")

  if File.exist?(schedule_file)
    Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)[:schedule]
  end
end
