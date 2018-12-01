class Admin < ApplicationRecord
  has_secure_password

  validates :username,
    presence: true,
    length: { within: 3..25 },
    format: {
      with: /\A[a-zA-Z0-9]+\z/,
      message: 'only alphanumerics',
    }

  validates :password,
    presence: true,
    length: { minimum: 4 }
end
