# Simple fix for Devise host issues
Rails.application.config.after_initialize do
  # Override the URL helper to always include host
  ActionMailer::Base.default_url_options = {
    host: 'sports-wager-tracker-production.up.railway.app',
    protocol: 'https'
  }
end