class Admin < ApplicationRecord
  with_options on: :login do |login|
    login.has_secure_password

    login.validates :username,
      presence: true,
      length: { within: 3..25 },
      format: {
        with: /\A[a-zA-Z0-9]+\z/,
        message: 'only alphanumerics',
      }

    login.validates :password,
      presence: true,
      length: { minimum: 4 }
  end

  with_options on: :recover do |recover|
    recover.validates :username,
      presence: false,
      length: { within: 3..25 },
      format: {
        with: /\A[a-zA-Z0-9]+\z/,
        message: 'must contains only alphanumeric',
      }
  end
  
  with_options on: :reset_password do |reset_password|
    reset_password.has_secure_password

    reset_password.validates :password,
      confirmation: true,
      length: { minimum: 4 }
    reset_password.validates :password_confirmation,
      presence: true
  end
end
