ENV['RAILS_ENV'] = 'production' unless ENV['RAILS_ENV']

require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile
Bundler.require(*Rails.groups)

module SportsWagerTracker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # DISABLE HOST AUTHORIZATION COMPLETELY
    config.hosts.clear
    config.middleware.delete ActionDispatch::HostAuthorization
    
    # Auto-migrate in production
    config.after_initialize do
      if Rails.env.production?
        begin
          ActiveRecord::Migrator.migrate(ActiveRecord::Tasks::DatabaseTasks.migrations_paths)
        rescue => e
          Rails.logger.error "Migration failed: #{e.message}"
        end
      end
    end
  end
end