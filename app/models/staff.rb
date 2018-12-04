class Staff < ApplicationRecord
  with_options on: :adds do |adds|
    adds.has_secure_password

    adds.validates :fullname,
      presence: true,
      length: { within: 3..255 },
      format: {
        with: /\A[a-zA-Z ]+\z/,
        message: 'must contains only alphabets and whitespace',
      }
    adds.validates :username,
      presence: true,
      length: { within: 3..25 },
      format: {
        with: /\A[a-zA-Z0-9]+\z/,
        message: 'must contains only alphanumeric',
      }
    adds.validates :password,
      confirmation: true,
      length: { minimum: 4 }
    adds.validates :password_confirmation,
      presence: true
  end

  with_options on: :edits do |edits|
    edits.has_secure_password

    edits.validates :fullname,
      presence: true,
      length: { within: 3..255 },
      format: {
        with: /\A[a-zA-Z ]+\z/,
        message: 'must contains only alphabets and whitespace',
      }
    edits.validates :password,
      confirmation: true,
      length: { minimum: 4 },
      allow_blank: true,
      allow_nil: true
    edits.validates :password_confirmation,
      presence: false,
      allow_blank: true,
      allow_nil: true
  end

  with_options on: :change_password do |change_password|
    change_password.has_secure_password

    change_password.validates :password,
      confirmation: true,
      length: { minimum: 4 }
    change_password.validates :password_confirmation,
      presence: true
  end
end
