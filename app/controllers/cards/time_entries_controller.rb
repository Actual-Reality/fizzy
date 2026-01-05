class Cards::TimeEntriesController < ApplicationController
  before_action :set_card

  def create
    @time_entry = @card.time_entries.new(time_entry_params)
    @time_entry.user = Current.user

    if @time_entry.save
      redirect_to @card, notice: "Time entry added."
    else
      redirect_to @card, alert: "Failed to add time entry. #{@time_entry.errors.full_messages.to_sentence}"
    end
  end

  def destroy
    @time_entry = @card.time_entries.find(params[:id])
    @time_entry.destroy
    redirect_to @card, notice: "Time entry removed."
  end

  private
    def set_card
      @card = Current.account.cards.find(params[:card_id])
    end

    def time_entry_params
      params.require(:time_entry).permit(:duration_string, :started_at, :description)
    end
end
