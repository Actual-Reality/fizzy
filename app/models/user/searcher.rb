module User::Searcher
  extend ActiveSupport::Concern

  included do
    has_many :search_queries, class_name: "Search::Query", dependent: :destroy
  end

  def search(terms)
    Search.new(self, terms).results
  end

  def remember_search(terms)
    search_queries.create(terms: terms) if search_queries.last&.terms != terms
  end
end
