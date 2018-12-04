class Visitor < ApplicationRecord
  with_options on: :adds do |adds|
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
    adds.validates :age,
      presence: true,
      length: { within: 0..150 }
  end

  with_options on: :edits do |edits|
    edits.validates :fullname,
      presence: true,
      length: { within: 3..255 },
      format: {
        with: /\A[a-zA-Z ]+\z/,
        message: 'must contains only alphabets and whitespace',
      }
    edits.validates :age,
      presence: true,
      length: { within: 0..150 }
  end
end
