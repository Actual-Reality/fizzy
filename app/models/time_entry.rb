class TimeEntry < ApplicationRecord
  belongs_to :card, touch: true
  belongs_to :user

  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :started_at, presence: true

  def duration_string
    return "" unless duration

    hours = duration / 60
    minutes = duration % 60

    if hours > 0 && minutes > 0
      "#{hours}h #{minutes}m"
    elsif hours > 0
      "#{hours}h"
    else
      "#{minutes}m"
    end
  end

  def duration_string=(value)
    self.duration = parse_duration(value)
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
