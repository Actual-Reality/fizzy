class Cards::ProjectsController < ApplicationController
  before_action :set_card

  def edit
  end

  def update
    @card.update(project_params)
    redirect_to @card, status: :see_other
  end

  private
    def set_card
      @card = Current.account.cards.find(params[:card_id])
    end

    def project_params
      params.expect(card: [ :project_id ])
    end
end
