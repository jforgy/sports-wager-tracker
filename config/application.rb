require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module SportsWagerTracker
  class Application < Rails::Application
    config.load_defaults 7.1

    # DISABLE HOST AUTHORIZATION
    config.hosts.clear
    config.middleware.delete ActionDispatch::HostAuthorization
    
    # Simple logging without complex migration logic
    config.after_initialize do
      if Rails.env.production?
        Rails.logger.info "Sports Wager Tracker starting in production mode"
      end
    end
  end
end