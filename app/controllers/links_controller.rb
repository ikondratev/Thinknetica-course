class LinksController < ApplicationController
  def destroy
    link = Link.find(params[:id])
    link.destroy
    redirect_back(fallback_location: question_path)
  end
end
