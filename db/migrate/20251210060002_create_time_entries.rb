class CreateTimeEntries < ActiveRecord::Migration[8.2]
  def change
    create_table :time_entries, id: :uuid do |t|
      t.references :card, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :duration
      t.datetime :started_at
      t.datetime :ended_at
      t.string :description

      t.timestamps
    end
  end
end
