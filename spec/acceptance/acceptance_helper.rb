require 'rails_helper'

RSpec.configure do |config|
  Capybara.javascript_driver = :webkit
  Capybara.server = :puma
  config.use_transactional_fixtures = false
  config.include AcceptanceMacros, type: :feature
  config.include OmniauthMacros

  config.before(:each) do
    OmniAuth.config.test_mode = true
  end

  config.after(:each) do
    OmniAuth.config.test_mode = nil
  end
end
