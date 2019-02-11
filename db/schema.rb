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

ActiveRecord::Schema.define(version: 2019_02_01_233019) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "adquisitions", force: :cascade do |t|
    t.bigint "car_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_adquisitions_on_car_id"
    t.index ["user_id"], name: "index_adquisitions_on_user_id"
  end

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
    t.decimal "amount", precision: 14, scale: 4
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
    t.string "engine"
    t.string "trim"
    t.string "odometer_unit"
    t.decimal "condition_report", precision: 3, scale: 2
    t.integer "release"
    t.string "cr_url"
    t.index ["body_style_id"], name: "index_cars_on_body_style_id"
    t.index ["exterior_color_id"], name: "index_cars_on_exterior_color_id"
    t.index ["fuel_type_id"], name: "index_cars_on_fuel_type_id"
    t.index ["interior_color_id"], name: "index_cars_on_interior_color_id"
    t.index ["model_id"], name: "index_cars_on_model_id"
    t.index ["vehicle_type_id"], name: "index_cars_on_vehicle_type_id"
    t.index ["vin"], name: "index_cars_on_vin", unique: true
  end

  create_table "cars_seller_types", id: false, force: :cascade do |t|
    t.integer "car_id", null: false
    t.integer "seller_type_id", null: false
    t.index ["car_id", "seller_type_id"], name: "index_cars_seller_types_on_car_id_and_seller_type_id"
  end

  create_table "colors", force: :cascade do |t|
    t.string "name"
    t.string "hex"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dealers", force: :cascade do |t|
    t.string "name"
    t.decimal "latitude", precision: 12, scale: 8
    t.decimal "longitude", precision: 12, scale: 8
    t.bigint "user_id"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country"
    t.string "city"
    t.string "address1"
    t.string "address2"
    t.index ["user_id"], name: "index_dealers_on_user_id"
  end

  create_table "file_attachments", force: :cascade do |t|
    t.string "owner_type"
    t.bigint "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.index ["owner_type", "owner_id"], name: "index_file_attachments_on_owner_type_and_owner_id"
  end

  create_table "file_directions", force: :cascade do |t|
    t.bigint "car_id"
    t.string "route"
    t.integer "order"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_file_directions_on_cars_id"
  end

  create_table "filters", force: :cascade do |t|
    t.integer "scope"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fuel_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "funds", force: :cascade do |t|
    t.decimal "balance", precision: 14, scale: 4
    t.decimal "amount", precision: 14, scale: 4
    t.bigint "user_id"
    t.bigint "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "credit"
    t.string "source_id"
    t.index ["payment_id"], name: "index_funds_on_payment_id"
    t.index ["user_id"], name: "index_funds_on_user_id"
  end

  create_table "general_configurations", primary_key: "key", id: :string, force: :cascade do |t|
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "mh_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "notifications", force: :cascade do |t|
    t.json "data"
    t.boolean "pending"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.bigint "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.boolean "mfa_authenticated", default: false
    t.string "phone_code"
    t.datetime "phone_code_sent_at"
    t.integer "phone_code_valid_till"
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
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

  create_table "risk_notices", force: :cascade do |t|
    t.bigint "user_id"
    t.decimal "maxmind_risk", precision: 5, scale: 2
    t.string "status"
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_risk_notices_on_user_id"
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

  create_table "sale_informations", force: :cascade do |t|
    t.bigint "car_id"
    t.string "channel"
    t.date "sale_date"
    t.string "auction_id"
    t.datetime "auction_start_date"
    t.datetime "auction_end_date"
    t.string "action_location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "current_bid", precision: 13, scale: 2
    t.index ["car_id"], name: "index_sale_informations_on_car_id"
  end

  create_table "seller_types", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "step_groups", force: :cascade do |t|
    t.string "name"
    t.integer "step_number"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "step_logs", force: :cascade do |t|
    t.bigint "step_group_id"
    t.text "description"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "adquisition_id"
    t.index ["adquisition_id"], name: "index_step_logs_on_adquisition_id"
    t.index ["step_group_id"], name: "index_step_logs_on_step_group_id"
  end

  create_table "subscribed_users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscriptions", force: :cascade do |t|
    t.bigint "user_id"
    t.boolean "payment_status"
    t.string "stripe_reference"
    t.date "payment_date"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
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
    t.string "username", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "city"
    t.string "phone_number"
    t.bigint "verified_by_id"
    t.boolean "verified", default: false
    t.string "primary_address"
    t.string "secondary_address"
    t.string "zip_code"
    t.string "country"
    t.boolean "phone_number_validated"
    t.boolean "require_2fa"
    t.string "authy_id"
    t.string "verification_code"
    t.datetime "activation_code_sent_at"
    t.integer "activation_code_valid_for"
    t.string "temp_id"
    t.string "stripe_customer"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
    t.index ["verified_by_id"], name: "index_users_on_verified_by_id"
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
    t.string "type_code"
  end

  add_foreign_key "adquisitions", "cars"
  add_foreign_key "adquisitions", "users"
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
  add_foreign_key "dealers", "users"
  add_foreign_key "file_directions", "cars"
  add_foreign_key "funds", "payments"
  add_foreign_key "funds", "users"
  add_foreign_key "models", "makers"
  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_grants", "users", column: "resource_owner_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "users", column: "resource_owner_id"
  add_foreign_key "payments", "users"
  add_foreign_key "payments", "users", column: "verified_by_id"
  add_foreign_key "risk_notices", "users"
  add_foreign_key "sale_informations", "cars"
  add_foreign_key "step_logs", "adquisitions"
  add_foreign_key "step_logs", "step_groups"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "users", "users", column: "verified_by_id"
  add_foreign_key "users_cars", "cars"
  add_foreign_key "users_cars", "users"
  add_foreign_key "users_questions", "questions"
  add_foreign_key "users_questions", "users"
end
