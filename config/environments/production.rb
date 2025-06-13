Rails.application.configure do
  # ... existing configuration ...

  # Allow Railway domain
  config.hosts << "sports-wager-tracker-production.up.railway.app"
  
  # Also allow with protocol variations
  config.hosts << ENV['RAILWAY_PUBLIC_DOMAIN'] if ENV['RAILWAY_PUBLIC_DOMAIN']

  # SendGrid email configuration (your existing email config)
  config.action_mailer.default_url_options = { host: ENV['RAILWAY_PUBLIC_DOMAIN'] || 'localhost' }
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.smtp_settings = {
    address: 'smtp.sendgrid.net',
    port: 587,
    domain: ENV['RAILWAY_PUBLIC_DOMAIN'],
    user_name: 'apikey',
    password: ENV['SENDGRID_API_KEY'],
    authentication: 'plain',
    enable_starttls_auto: true
  }

  # ... rest of existing configuration ...
end