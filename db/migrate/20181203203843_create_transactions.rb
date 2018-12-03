class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.string :staff_username
      t.string :visitor_username
      t.string :book_isbn
      t.boolean :is_borrowing

      t.timestamps
    end
    add_index :transactions, :staff_username
    add_index :transactions, :visitor_username
    add_index :transactions, :book_isbn
    add_index :transactions, :is_borrowing
  end
end
