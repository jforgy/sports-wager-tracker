source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.4.4"

gem "rails", "~> 7.1.0"
gem "puma", "~> 6.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder", "~> 2.7"
gem "bootsnap", ">= 1.4.4", require: false
gem "devise"
gem "bootstrap", "~> 5.2"
gem "sassc-rails"
gem"tzinfo-data"
gem "csv"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "web-console"
  gem "sqlite3", "~> 1.4"  # SQLite only for development
end

group :production do
  gem "pg", "~> 1.1"  # PostgreSQL for production
end