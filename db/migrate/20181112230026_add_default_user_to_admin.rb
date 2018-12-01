class AddDefaultUserToAdmin < ActiveRecord::Migration[5.2]
  def up
    Admin.new(username: 'admin', password: 'admin').save
  end

  def down
    Admin.delete_all
  end
end
