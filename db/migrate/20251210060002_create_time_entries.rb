class CreateTimeEntries < ActiveRecord::Migration[8.2]
  def change
    create_table :time_entries, id: :uuid do |t|
      t.references :card, null: false, foreign_key: true, type: :uuid
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.integer :duration
      t.date :started_at
      t.string :description, null: false

      t.timestamps
    end
  end
end
