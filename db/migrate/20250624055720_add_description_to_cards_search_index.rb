class AddDescriptionToCardsSearchIndex < ActiveRecord::Migration[8.1]
  def change
    execute <<~SQL
      DROP TABLE cards_search_index;
    SQL
    create_virtual_table :cards_search_index, "fts5", [ "title", "description" ]
  end
end
