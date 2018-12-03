class CreateVisitors < ActiveRecord::Migration[5.2]
  def change
    create_table :visitors do |t|
      t.string :fullname
      t.string :username
      t.integer :age

      t.timestamps
    end
    add_index :visitors, :username
  end
end
