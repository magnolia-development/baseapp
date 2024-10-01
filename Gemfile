# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.3.5"

gem "bootsnap", require: false
gem "cssbundling-rails"
gem "dotenv"
gem "importmap-rails"
gem "jbuilder"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "rails", "~> 7.2.1"
gem "sprockets-rails"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[mri windows mingw x64_mingw], require: "debug/prelude"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails", "~> 6.0"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "hotwire-livereload", "~> 1.2"
  gem "letter_opener"
  gem "rubocop-rails"
  gem "rubocop-rspec"
  gem "rubocop-rspec_rails"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "database_cleaner-active_record"
  gem "email_spec"
  gem "rails-controller-testing"
  gem "selenium-webdriver"
  gem "shoulda-matchers"
  gem "webdrivers"
end

