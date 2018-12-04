class Book < ApplicationRecord
  with_options on: :adds do |adds|
    adds.validates :isbn,
      presence: true

    adds.validates :title,
      presence: true

    adds.validates :author,
      presence: true

    adds.validates :synopsis,
      presence: true
  end

  with_options on: :edits do |edits|
    edits.validates :title,
      presence: true

    edits.validates :author,
      presence: true

    edits.validates :synopsis,
      presence: true
  end
end
