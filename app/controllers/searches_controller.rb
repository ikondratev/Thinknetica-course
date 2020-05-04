class SearchesController < ApplicationController
  skip_authorization_check

  def index
    @results = SearchService.search_by(params[:search_line], params[:thing])
  end
end
