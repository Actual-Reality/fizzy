class Cards::ReadingsController < ApplicationController
  include CardScoped

  def create
    @notification = Current.user.notifications.find_by(card: @card)
    @notification.read
  end
end
