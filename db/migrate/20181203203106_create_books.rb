class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :isbn
      t.string :title
      t.string :author
      t.string :synopsis
      t.integer :stock

      t.timestamps
    end
    add_index :books, :isbn
  end
end
