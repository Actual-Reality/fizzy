class ImproveTimeEntries < ActiveRecord::Migration[8.2]
  def change
    # Change started_at to datetime
    change_column :time_entries, :started_at, :datetime

    # Add ended_at
    add_column :time_entries, :ended_at, :datetime

    # Relax duration constraint (allow null for running timers)
    change_column_null :time_entries, :duration, true
  end
end
