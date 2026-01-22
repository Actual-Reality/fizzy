class LongRunningTimerNotifierJob < ApplicationJob
  queue_as :default

  def perform
    # Notify for timers running longer than 8 hours
    TimeEntry.running.where("started_at < ?", 8.hours.ago).find_each do |entry|
      # In a real implementation, we would check if a notification was already sent
      # to avoid spamming the user.
      Rails.logger.warn "Long running timer alert: User #{entry.user.id} has been working on '#{entry.card.title}' for over 8 hours."

      # Example notification creation (if system allows duplicate notifications or we tracked it)
      # Notification.create!(
      #   user: entry.user,
      #   creator: entry.user, # System notification?
      #   source: entry,
      #   account: entry.card.account
      # )
    end
  end
end
