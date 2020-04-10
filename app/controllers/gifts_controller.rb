class GiftsController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def index
    @gifts = current_user.gifts
  end
end
