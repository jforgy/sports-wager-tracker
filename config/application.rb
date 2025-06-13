ENV['RAILS_ENV'] ||= 'production'
require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SportsWagerTracker
  class Application < Rails::Application
    config.load_defaults 7.1

    # NUCLEAR OPTION - completely disable host authorization
    config.hosts.clear
    config.middleware.delete ActionDispatch::HostAuthorization
    
    # Force disable host authorization another way
    config.force_ssl = false
  end
end
