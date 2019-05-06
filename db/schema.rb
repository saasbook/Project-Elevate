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

ActiveRecord::Schema.define(version: 2019_04_25_213247) do

  create_table "calendars", force: :cascade do |t|
    t.string "name"
    t.integer "UserId"
    t.integer "OtherId"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean "typeEvent"
    t.string "event_day"
    t.string "event_month"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "coach_availabilities", force: :cascade do |t|
    t.integer "coach_id", null: false
    t.integer "player_id"
    t.string "day", null: false
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "membership_histories", force: :cascade do |t|
    t.integer "user_changed_id", null: false
    t.integer "changed_by_id", null: false
    t.string "old_membership", null: false
    t.string "new_membership", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payment_packages", force: :cascade do |t|
    t.string "name", null: false
    t.integer "num_classes", null: false
    t.integer "price", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: "", null: false
    t.string "membership", default: "Club Member", null: false
    t.string "my_admin", default: "", null: false
    t.string "custom_num_credit", default: "0", null: false
    t.string "assigned_num_credit", default: "0", null: false
    t.string "group_num_credit", default: "0", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
