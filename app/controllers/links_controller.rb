class LinksController < ApplicationController
  def destroy
    @link = Link.find(params[:id])

    authorize! :destroy, @link

    @link.destroy
    redirect_back(fallback_location: question_path)
  end
end
