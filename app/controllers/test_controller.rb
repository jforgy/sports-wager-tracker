class TestController < ApplicationController
  skip_before_action :authenticate_user!
  
  def email
    begin
      Rails.logger.info "=== EMAIL TEST START ==="
      Rails.logger.info "Delivery method: #{ActionMailer::Base.delivery_method}"
      Rails.logger.info "Perform deliveries: #{ActionMailer::Base.perform_deliveries}"
      Rails.logger.info "SMTP settings: #{ActionMailer::Base.smtp_settings.inspect}"
      
      # Check if we're actually using SMTP
      if ActionMailer::Base.delivery_method != :smtp
        return render plain: "ERROR: Delivery method is #{ActionMailer::Base.delivery_method}, not SMTP!"
      end
      
      if ENV['SENDGRID_API_KEY'].blank?
        return render plain: "ERROR: SENDGRID_API_KEY is not set!"
      end
      
      TestMailer.test_email('forgy.josh@gmail.com').deliver_now
      
      render plain: "Email sent via #{ActionMailer::Base.delivery_method} successfully! Check SendGrid activity."
    rescue => e
      render plain: "Email failed: #{e.message}"
    end
  end
  
  def env_check
    output = "SENDGRID_API_KEY present: #{ENV['SENDGRID_API_KEY'].present?}\n"
    output += "SENDGRID_API_KEY length: #{ENV['SENDGRID_API_KEY']&.length}\n"
    output += "SENDGRID_API_KEY starts with SG: #{ENV['SENDGRID_API_KEY']&.start_with?('SG.')}\n"
    output += "RAILS_ENV: #{ENV['RAILS_ENV']}\n"
    output += "Delivery method: #{ActionMailer::Base.delivery_method}\n"
    output += "Perform deliveries: #{ActionMailer::Base.perform_deliveries}\n"
    output += "SMTP settings: #{ActionMailer::Base.smtp_settings.inspect}\n"
    render plain: output
  end
end