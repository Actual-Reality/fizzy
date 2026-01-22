class MakeDescriptionNullableInTimeEntries < ActiveRecord::Migration[8.2]
  def change
    change_column_null :time_entries, :description, true
  end
end