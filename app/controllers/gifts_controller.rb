class GiftsController < ApplicationController
  before_action :authenticate_user!

  def index
    @gifts = current_user.gifts
  end
end
