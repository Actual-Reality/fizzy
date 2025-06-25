module Search::QueryTermsScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_query_terms
  end

  private
    def set_query_terms
      @query_terms = params[:q]
    end
end
