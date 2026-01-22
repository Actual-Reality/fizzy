class AddIndexToTimeEntriesForRunningTimers < ActiveRecord::Migration[8.2]
  def change
    add_index :time_entries, [:user_id, :ended_at, :duration], 
              name: "index_time_entries_on_user_id_and_running"
  end
end
