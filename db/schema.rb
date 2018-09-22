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

ActiveRecord::Schema.define(version: 2018_09_22_193402) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bid_collectors", force: :cascade do |t|
    t.integer "count"
    t.bigint "car_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "highest_id"
    t.index ["car_id"], name: "index_bid_collectors_on_car_id"
    t.index ["highest_id"], name: "index_bid_collectors_on_highest_id"
  end

  create_table "bids", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.bigint "user_id"
    t.bigint "bid_collector_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bid_collector_id"], name: "index_bids_on_bid_collector_id"
    t.index ["user_id"], name: "index_bids_on_user_id"
  end

  create_table "body_styles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cars", force: :cascade do |t|
    t.integer "year"
    t.bigint "model_id"
    t.string "tim"
    t.integer "odometer"
    t.bigint "fuel_type_id"
    t.string "displacement"
    t.boolean "transmission"
    t.string "vin"
    t.bigint "body_style_id"
    t.integer "doors"
    t.bigint "vehicle_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "interior_color_id"
    t.bigint "exterior_color_id"
    t.datetime "sale_date"
    t.decimal "condition", precision: 5, scale: 2
    t.index ["body_style_id"], name: "index_cars_on_body_style_id"
    t.index ["exterior_color_id"], name: "index_cars_on_exterior_color_id"
    t.index ["fuel_type_id"], name: "index_cars_on_fuel_type_id"
    t.index ["interior_color_id"], name: "index_cars_on_interior_color_id"
    t.index ["model_id"], name: "index_cars_on_model_id"
    t.index ["vehicle_type_id"], name: "index_cars_on_vehicle_type_id"
    t.index ["vin"], name: "index_cars_on_vin", unique: true
  end

  create_table "colors", force: :cascade do |t|
    t.string "name"
    t.string "hex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fuel_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "funds", force: :cascade do |t|
    t.decimal "past_balance", precision: 14, scale: 4
    t.decimal "current_amount", precision: 14, scale: 4
    t.bigint "user_id"
    t.bigint "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_id"], name: "index_funds_on_payment_id"
    t.index ["user_id"], name: "index_funds_on_user_id"
  end

  create_table "makers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "models", force: :cascade do |t|
    t.bigint "maker_id"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["maker_id"], name: "index_models_on_maker_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "amount", precision: 14, scale: 4
    t.boolean "verified"
    t.text "payment_note"
    t.bigint "verified_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_payments_on_user_id"
    t.index ["verified_by_id"], name: "index_payments_on_verified_by_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "question"
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.bigint "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource_type_and_resource_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.string "first_name"
    t.string "last_name"
    t.string "city"
    t.string "street_address"
    t.string "phone_number"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "users_cars", primary_key: ["user_id", "car_id"], force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "car_id", null: false
    t.index ["car_id"], name: "index_users_cars_on_car_id"
    t.index ["user_id"], name: "index_users_cars_on_user_id"
  end

  create_table "users_questions", primary_key: ["user_id", "question_id"], force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "question_id", null: false
    t.string "answer"
    t.index ["question_id"], name: "index_users_questions_on_question_id"
    t.index ["user_id"], name: "index_users_questions_on_user_id"
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  create_table "vehicle_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "bid_collectors", "bids", column: "highest_id"
  add_foreign_key "bid_collectors", "cars"
  add_foreign_key "bids", "bid_collectors"
  add_foreign_key "bids", "users"
  add_foreign_key "cars", "body_styles"
  add_foreign_key "cars", "colors", column: "exterior_color_id"
  add_foreign_key "cars", "colors", column: "interior_color_id"
  add_foreign_key "cars", "fuel_types"
  add_foreign_key "cars", "models"
  add_foreign_key "cars", "vehicle_types"
  add_foreign_key "funds", "payments"
  add_foreign_key "funds", "users"
  add_foreign_key "models", "makers"
  add_foreign_key "payments", "users"
  add_foreign_key "payments", "users", column: "verified_by_id"
  add_foreign_key "users_cars", "cars", name: "cars___fk"
  add_foreign_key "users_cars", "users", name: "users_fk"
  add_foreign_key "users_questions", "questions"
  add_foreign_key "users_questions", "users"
end
