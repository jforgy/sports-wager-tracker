require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module SportsWagerTracker
  class Application < Rails::Application
    config.load_defaults 7.1

    # DISABLE HOST AUTHORIZATION
    config.hosts.clear
    config.middleware.delete ActionDispatch::HostAuthorization
    
    # Auto-migrate as backup if release command fails
    config.after_initialize do
      if Rails.env.production?
        begin
          Rails.logger.info "Checking for pending migrations..."
          if ActiveRecord::Base.connection.migration_context.needs_migration?
            Rails.logger.info "Running migrations..."
            ActiveRecord::Base.connection.migration_context.migrate
            Rails.logger.info "Migrations completed!"
          end
        rescue => e
          Rails.logger.info "Migration check skipped: #{e.message}"
        end
      end
    end
  end
end