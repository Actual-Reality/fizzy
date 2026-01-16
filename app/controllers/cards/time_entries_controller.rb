class Cards::TimeEntriesController < ApplicationController
  before_action :set_card

  def create
    @time_entry = @card.time_entries.new(time_entry_params)
    @time_entry.user = Current.user

    if @time_entry.save
      redirect_to @card, notice: "Time entry added.", status: :see_other
    else
      redirect_to @card, alert: "Failed to add time entry. #{@time_entry.errors.full_messages.to_sentence}", status: :see_other
    end
  end

  def start
    # Stop any other running timers for this user
    Current.user.time_entries.running.find_each(&:stop!)

    @time_entry = @card.time_entries.new(started_at: Time.current, user: Current.user, description: "Working on task")

    if @time_entry.save
      redirect_to @card, notice: "Timer started.", status: :see_other
    else
      redirect_to @card, alert: "Failed to start timer.", status: :see_other
    end
  end

  def stop
    @time_entry = @card.time_entries.running.where(user: Current.user).last

    if @time_entry&.stop!
      redirect_to @card, notice: "Timer stopped. Duration: #{@time_entry.duration_string}", status: :see_other
    else
      redirect_to @card, alert: "No running timer found or failed to stop.", status: :see_other
    end
  end

  def update
    @time_entry = @card.time_entries.find(params[:id])

    unless @time_entry.user == Current.user || Current.user.admin?
      redirect_to @card, alert: "You can only edit your own time entries.", status: :see_other
      return
    end

    if @time_entry.update(time_entry_params)
      redirect_to @card, status: :see_other
    else
      redirect_to @card, alert: "Failed to update time entry.", status: :see_other
    end
  end

  def destroy
    @time_entry = @card.time_entries.find(params[:id])

    if @time_entry.user == Current.user || Current.user.admin?
      @time_entry.destroy
      redirect_to @card, notice: "Time entry removed.", status: :see_other
    else
      redirect_to @card, alert: "You can only delete your own time entries.", status: :see_other
    end
  end

  private
    def set_card
      @card = Current.account.cards.find_by!(number: params[:card_id])
    end

    def time_entry_params
      params.expect(time_entry: [ :duration_string, :started_at, :description ])
    end
end
