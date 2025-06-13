if Rails.env.production?
  Rails.application.config.after_initialize do
    Rails.logger.info "=== SendGrid Configuration Test ==="
    Rails.logger.info "API Key present: #{ENV['SENDGRID_API_KEY'].present?}"
    Rails.logger.info "API Key starts with SG.: #{ENV['SENDGRID_API_KEY']&.start_with?('SG.')}"
    Rails.logger.info "From Email: #{ENV['SENDGRID_FROM_EMAIL']}"
    Rails.logger.info "SMTP Settings: #{ActionMailer::Base.smtp_settings}"
    Rails.logger.info "=================================="
  end
end