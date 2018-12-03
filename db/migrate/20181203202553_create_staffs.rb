class CreateStaffs < ActiveRecord::Migration[5.2]
  def change
    create_table :staffs do |t|
      t.string :fullname
      t.string :username
      t.string :password_digest

      t.timestamps
    end
    add_index :staffs, :username
  end
end
