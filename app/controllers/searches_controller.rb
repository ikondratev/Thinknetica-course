class SearchesController < ApplicationController
  skip_authorization_check

  def index
    @results = SearchService.search_by(params[:query], params[:type])
  end
end
