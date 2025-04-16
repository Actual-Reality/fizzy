class Notifications::ReadingsController < ApplicationController
  def create
    @notification = Current.user.notifications.find(params[:id])
    @notification.read
  end

  def create_all
    Current.user.notifications.unread.read_all
    redirect_to notifications_path
  end
end
