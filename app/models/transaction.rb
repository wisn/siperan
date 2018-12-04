class Transaction < ApplicationRecord
  with_options on: :transaction do |transaction|
    transaction.validates :visitor_username,
      presence: true

    transaction.validates :book_isbn,
      presence: true
  end
end
