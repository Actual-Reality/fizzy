class CreateProjects < ActiveRecord::Migration[8.2]
  def change
    create_table :projects, id: :uuid do |t|
      t.string :name
      t.text :description
      t.references :account, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
