require_relative "boot"
require "rails/all"

Bundler.require(*Rails.groups)

module SportsWagerTracker
  class Application < Rails::Application
    config.load_defaults 7.1

    # DISABLE HOST AUTHORIZATION
    config.hosts.clear
    config.middleware.delete ActionDispatch::HostAuthorization
    
    # Auto-migrate with connection retries
    config.after_initialize do
      if Rails.env.production?
        # Wait for database to be ready with retries
        max_retries = 10
        retry_count = 0
        
        begin
          Rails.logger.info "Attempting database connection (attempt #{retry_count + 1}/#{max_retries})..."
          
          # Test connection
          ActiveRecord::Base.connection.execute("SELECT 1")
          Rails.logger.info "Database connected successfully!"
          
          # Run migrations if needed
          if ActiveRecord::Base.connection.migration_context.needs_migration?
            Rails.logger.info "Running pending migrations..."
            ActiveRecord::Base.connection.migration_context.migrate
            Rails.logger.info "Migrations completed!"
          else
            Rails.logger.info "No pending migrations"
          end
          
        rescue PG::ConnectionBad, ActiveRecord::ConnectionNotEstablished => e
          retry_count += 1
          if retry_count < max_retries
            Rails.logger.warn "Database connection failed (#{e.message}), retrying in 3 seconds..."
            sleep(3)
            retry
          else
            Rails.logger.error "Database connection failed after #{max_retries} attempts: #{e.message}"
          end
        rescue => e
          Rails.logger.error "Migration error: #{e.message}"
        end
      end
    end
  end
end