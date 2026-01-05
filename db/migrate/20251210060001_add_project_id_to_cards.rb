class AddProjectIdToCards < ActiveRecord::Migration[8.2]
  def change
    add_reference :cards, :project, null: true, foreign_key: true, type: :uuid
  end
end
