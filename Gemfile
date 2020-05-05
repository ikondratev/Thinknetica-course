# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.5'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.0.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 4.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.6'
# Transpile app-like JavaScript. Read more: https://github.com/rails/webpacker
gem 'webpacker',  '~> 4.x'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.7'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 4.0'
# Use Active Model has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Active Storage variant
# gem 'image_processing', '~> 1.2'

# Reduces boot times through caching; required in config/boot.rb
gem 'active_model_serializers', '~> 0.10'
gem 'bootsnap', '>= 1.4.2', require: false
gem 'cancancan'
gem "cocoon"
gem 'devise'
gem 'doorkeeper'
gem 'gon'
gem 'jquery-rails'
gem 'mysql2'
gem "octokit"
gem 'oj'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'pry-rails'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'skim'
gem 'slim-rails'
gem 'thinking-sphinx'
gem 'validate_url'
gem 'whenever', require: false
gem 'mini_racer'
gem 'unicorn'

gem 'capybara-email'
gem "letter_opener", group: :development
gem 'sprockets'
gem 'sprockets-rails'
gem 'listen', '>= 3.0.5', '< 3.2'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'factory_bot_rails'
  gem 'rspec-rails', '~> 4.0-dev'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-passenger', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'rails-controller-testing'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'launchy'
  gem 'webdrivers'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "aws-sdk-s3"
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
