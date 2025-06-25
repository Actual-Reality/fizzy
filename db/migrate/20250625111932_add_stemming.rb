class AddStemming < ActiveRecord::Migration[8.1]
  def change
    drop_table :cards_search_index
    drop_table :comments_search_index

    create_virtual_table "cards_search_index", "fts5", [ "title", "description", "tokenize='porter'" ]
    create_virtual_table "comments_search_index", "fts5", [ "body", "tokenize='porter'" ]
  end
end
