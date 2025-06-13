Rails.application.configure do
  # COMPLETELY disable host checking - should work for any hostname
  config.hosts.clear
  
  # Alternative - allow everything
  config.force_ssl = false
  config.hosts << /.*/ 
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
    domain: 'sendgrid.net',
    user_name: 'apikey',  # This should literally be "apikey"
    password: ENV['SENDGRID_API_KEY'],  # Your actual API key
    authentication: :plain,
    enable_starttls_auto: true
  }

end