class AddDefaultUserToAdmin < ActiveRecord::Migration[5.2]
  def up
    Admin.new(
      username: 'admin',
      password: 'admin',
      recovery_question: 'What is your role on SIPERAN?',
      recovery_answer: 'admin',
    ).save
  end

  def down
    Admin.delete_all
  end
end
