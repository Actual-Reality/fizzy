class TimeEntry < ApplicationRecord
  belongs_to :card, touch: true
  belongs_to :user

  validates :duration, presence: true, numericality: { greater_than: 0 }, unless: :running?
  validates :started_at, presence: true

  scope :running, -> { where(ended_at: nil, duration: nil) }
  scope :completed, -> { where.not(duration: nil) }

  def self.format_duration(minutes)
    return "" unless minutes && minutes > 0

    hours = minutes / 60
    mins = minutes % 60

    if hours > 0 && mins > 0
      "#{hours}h #{mins}m"
    elsif hours > 0
      "#{hours}h"
    else
      "#{mins}m"
    end
  end

  def duration_string
    self.class.format_duration(duration)
  end

  def duration_string=(value)
    self.duration = parse_duration(value)
  end

  def running?
    started_at.present? && ended_at.nil? && duration.nil?
  end

  def stop!
    return unless running?

    self.ended_at = Time.current
    self.duration = ((ended_at - started_at) / 60).to_i # Calculate duration in minutes
    self.duration = 1 if self.duration < 1 # Ensure at least 1 minute
    save!
  end

  private
    def parse_duration(string)
      return 0 if string.blank?

      total_minutes = 0

      if string.match?(/(\d+)\s*h/)
        total_minutes += string[/(\d+)\s*h/, 1].to_i * 60
      end

      if string.match?(/(\d+)\s*m/)
        total_minutes += string[/(\d+)\s*m/, 1].to_i
      end

      if total_minutes == 0 && string.match?(/^\d+$/)
        total_minutes = string.to_i
      end

      total_minutes
    end
end
