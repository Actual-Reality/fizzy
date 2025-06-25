class SearchesController < ApplicationController
  include Search::QueryTermsScoped

  def show
    @search_results = Current.user.search(@query_terms).limit(50)
    @recent_search_queries = Current.user.search_queries.order(created_at: :desc).limit(10)
  end
end
