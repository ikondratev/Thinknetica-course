# frozen_string_literal: true

class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: [exception.message], status: 403 }
      format.html { redirect_to root_url, alert: exception.message }
      format.js   { render 'shared/errors', locals: { item: exception.message } }
    end
  end
end
