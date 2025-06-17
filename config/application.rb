require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module SportsWagerTracker
  class Application < Rails::Application
    config.load_defaults 7.1

    # DISABLE HOST AUTHORIZATION
    config.hosts.clear
    config.middleware.delete ActionDispatch::HostAuthorization
    
    # Auto-migrate on startup in production
    config.after_initialize do
      if Rails.env.production?
        begin
          Rails.logger.info "Checking database connection..."
          
          # Wait a moment for database to be ready
          sleep(2)
          
          # Test connection
          ActiveRecord::Base.connection.execute("SELECT 1")
          Rails.logger.info "Database connected successfully"
          
          # Check and run migrations
          if ActiveRecord::Base.connection.migration_context.needs_migration?
            Rails.logger.info "Pending migrations found, running now..."
            ActiveRecord::Base.connection.migration_context.migrate
            Rails.logger.info "Migrations completed successfully!"
          else
            Rails.logger.info "No pending migrations"
          end
          
        rescue ActiveRecord::NoDatabaseError => e
          Rails.logger.error "Database does not exist: #{e.message}"
        rescue PG::ConnectionBad => e
          Rails.logger.error "Cannot connect to database: #{e.message}"
        rescue => e
          Rails.logger.error "Migration error: #{e.message}"
          Rails.logger.error "Backtrace: #{e.backtrace.join('\n')}"
        end
      end
    end
  end
end