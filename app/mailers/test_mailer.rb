class TestMailer < ApplicationMailer
  default from: 'forgy.josh@gmail.com'
  
  def test_email(email)
    mail(
      to: email,
      subject: 'Test Email from Sports Wager Tracker',
      body: 'This is a test email to verify SendGrid is working.'
    )
  end
end