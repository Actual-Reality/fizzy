class GenerateNotificationsJob < ApplicationJob
  queue_as :default

  def perform(event)
    event.generate_notifications
  end
end
