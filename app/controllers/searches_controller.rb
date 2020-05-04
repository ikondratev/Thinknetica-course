class SearchesController < ApplicationController
  skip_authorization_check

  def index
  	binding.pry
    @results = SearchService.search_by(params[:query], params[:type])
  end
end
