class Searches::QueriesController < ApplicationController
  include Search::QueryTermsScoped

  def create
    Current.user.remember_search(@query_terms)
    head :ok
  end
end
