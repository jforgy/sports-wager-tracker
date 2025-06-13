class TestController < ApplicationController
  skip_before_action :authenticate_user!
  
  def email
    begin
      # Try to send a simple test email
      TestMailer.test_email('forgy.josh@gmail.com').deliver_now
      render plain: "Email sent successfully!"
    rescue => e
      render plain: "Email failed: #{e.message}"
    end
  end
end