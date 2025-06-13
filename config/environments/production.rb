Rails.application.configure do
  # COMPLETELY disable host checking - should work for any hostname
  config.hosts.clear
  
  # Alternative - allow everything
  config.force_ssl = false
  config.hosts << /.*/ 

  # SendGrid email configuration (your existing email config)
  config.action_mailer.default_url_options = { 
    host: 'sports-wager-tracker-production.up.railway.app',
    protocol: 'https'
  }
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