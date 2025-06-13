Rails.application.configure do
  # Force log this immediately
  puts "=== PRODUCTION CONFIG LOADING ==="
  puts "RAILS_ENV: #{ENV['RAILS_ENV']}"
  puts "==================================="

  # Basic production settings
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local = false
  config.action_controller.perform_caching = true
  
  # DISABLE all asset pipeline issues
  config.require_master_key = false
  config.public_file_server.enabled = true
  config.assets.compile = false
  config.assets.digest = false
  config.serve_static_assets = true

  # Clear hosts
  config.hosts.clear

  # Email configuration
  config.action_mailer.default_url_options = { 
    host: 'sports-wager-tracker-production.up.railway.app',
    protocol: 'https'
  }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  
  config.action_mailer.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: 587,
    user_name: 'apikey',
    password: ENV['SENDGRID_API_KEY'],
    authentication: :plain,
    enable_starttls_auto: true,
    domain: 'railway.app'
  }

  # Debug email config
  config.after_initialize do
    puts "=== EMAIL CONFIG DEBUG ==="
    puts "Delivery method: #{ActionMailer::Base.delivery_method}"
    puts "API Key present: #{ENV['SENDGRID_API_KEY'].present?}"
    puts "==========================="
  end
end