require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module SportsWagerTracker
  class Application < Rails::Application
    config.load_defaults 7.1

    # DISABLE HOST AUTHORIZATION
    config.hosts.clear
    config.middleware.delete ActionDispatch::HostAuthorization
    
    # Simple database connection check (no complex migration logic)
    config.after_initialize do
      if Rails.env.production?
        begin
          Rails.logger.info "Testing database connection..."
          ActiveRecord::Base.connection.execute("SELECT 1")
          Rails.logger.info "Database connection successful!"
        rescue => e
          Rails.logger.error "Database connection failed: #{e.message}"
        end
      end
    end
  end
end