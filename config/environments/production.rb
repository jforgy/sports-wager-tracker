require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  
  # DISABLE MASTER KEY REQUIREMENT
  config.require_master_key = false
  
  config.public_file_server.enabled = true
  config.assets.compile = true
  config.assets.digest = false

  # Clear hosts
  config.hosts.clear

  # Disable SSL for Railway
  config.force_ssl = false

  # Generate secret key base from environment variable or random
  config.secret_key_base = ENV['SECRET_KEY_BASE'] || SecureRandom.hex(64)

  # Logging
  config.log_level = :info
  config.log_tags = [ :request_id ]

  # Don't care about missing translations
  config.i18n.raise_on_missing_translations = false
end