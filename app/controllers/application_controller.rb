# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def default_url_options
    if Rails.env.production?
      Rails.application.routes.default_url_options = { host: "www.production-domain.com", protocol: 'https' }
    elsif Rails.env.development?
      Rails.application.routes.default_url_options = { host: 'localhost:3000', protocol: 'http' }
    end
end
end
