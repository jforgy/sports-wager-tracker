Rails.application.configure do
  # Put debug at the very beginning
  puts "=== EMAIL DEBUG START ==="
  puts "Rails env: #{Rails.env}"
  puts "=== EMAIL DEBUG END ==="

  # ... your existing configuration ...

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

  # Debug email config after setting it
  config.after_initialize do
    puts "=== EMAIL CONFIG DEBUG ==="
    puts "Delivery method: #{ActionMailer::Base.delivery_method}"
    puts "Perform deliveries: #{ActionMailer::Base.perform_deliveries}"
    puts "SMTP settings: #{ActionMailer::Base.smtp_settings.inspect}"
    puts "API Key present: #{ENV['SENDGRID_API_KEY'].present?}"
    puts "API Key length: #{ENV['SENDGRID_API_KEY']&.length}"
    puts "==========================="
  end

  # ... rest of your configuration ...
end