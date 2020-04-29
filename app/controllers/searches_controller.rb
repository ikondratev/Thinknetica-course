class SearchesController < ApplicationController
  authorize_resource

  def show
    @results = SearchService.search_by(params[:query], params[:type])
  end
end
