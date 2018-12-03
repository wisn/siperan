# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2018_12_03_203843) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "recovery_question"
    t.string "recovery_answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_admins_on_username"
  end

  create_table "books", force: :cascade do |t|
    t.string "isbn"
    t.string "title"
    t.string "author"
    t.string "synopsis"
    t.integer "stock"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["isbn"], name: "index_books_on_isbn"
  end

  create_table "staffs", force: :cascade do |t|
    t.string "fullname"
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_staffs_on_username"
  end

  create_table "transactions", force: :cascade do |t|
    t.string "staff_username"
    t.string "visitor_username"
    t.string "book_isbn"
    t.boolean "is_borrowing"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_isbn"], name: "index_transactions_on_book_isbn"
    t.index ["is_borrowing"], name: "index_transactions_on_is_borrowing"
    t.index ["staff_username"], name: "index_transactions_on_staff_username"
    t.index ["visitor_username"], name: "index_transactions_on_visitor_username"
  end

  create_table "visitors", force: :cascade do |t|
    t.string "fullname"
    t.string "username"
    t.integer "age"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_visitors_on_username"
  end

end
