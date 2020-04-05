require 'rails_helper'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit
  Capybara.server = :puma
  config.use_transactional_fixtures = false
  config.include AcceptanceMacros, type: :feature
  config.include OmniauthMacros

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.before(:each) do
    OmniAuth.config.test_mode = true
  end

  config.after(:each) do
    DatabaseCleaner.clean
    OmniAuth.config.test_mode = nil
  end
end
