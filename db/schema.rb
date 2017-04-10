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

ActiveRecord::Schema.define(version: 20170410090735) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attachinary_files", force: :cascade do |t|
    t.string   "attachinariable_type"
    t.integer  "attachinariable_id"
    t.string   "scope"
    t.string   "public_id"
    t.string   "version"
    t.integer  "width"
    t.integer  "height"
    t.string   "format"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["attachinariable_type", "attachinariable_id", "scope"], name: "by_scoped_parent", using: :btree
  end

  create_table "meal_categories", force: :cascade do |t|
    t.string   "name"
    t.integer  "restaurant_id"
    t.integer  "position"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "timing"
    t.boolean  "active",        default: true
    t.string   "photo"
    t.index ["restaurant_id"], name: "index_meal_categories_on_restaurant_id", using: :btree
  end

  create_table "meal_options", force: :cascade do |t|
    t.integer  "meal_id"
    t.integer  "option_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["meal_id"], name: "index_meal_options_on_meal_id", using: :btree
    t.index ["option_id"], name: "index_meal_options_on_option_id", using: :btree
  end

  create_table "meals", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "price_cents"
    t.integer  "tax_rate",         default: 0
    t.string   "photo"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "active",           default: true
    t.integer  "position"
    t.integer  "meal_category_id"
    t.index ["meal_category_id"], name: "index_meals_on_meal_category_id", using: :btree
  end

  create_table "menu_meal_categories", force: :cascade do |t|
    t.integer  "menu_id"
    t.integer  "meal_category_id"
    t.integer  "quantity",         default: 1
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["meal_category_id"], name: "index_menu_meal_categories_on_meal_category_id", using: :btree
    t.index ["menu_id"], name: "index_menu_meal_categories_on_menu_id", using: :btree
  end

  create_table "menus", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "price_cents",               null: false
    t.integer  "tax_rate",      default: 0
    t.integer  "restaurant_id"
    t.integer  "position"
    t.index ["restaurant_id"], name: "index_menus_on_restaurant_id", using: :btree
  end

  create_table "options", force: :cascade do |t|
    t.string   "name"
    t.integer  "restaurant_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.integer  "position"
    t.boolean  "active",        default: true
    t.index ["restaurant_id"], name: "index_options_on_restaurant_id", using: :btree
  end

  create_table "order_elements", force: :cascade do |t|
    t.integer  "order_id"
    t.string   "element_type"
    t.integer  "element_id"
    t.integer  "quantity",     default: 1
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.index ["element_type", "element_id"], name: "index_order_elements_on_element_type_and_element_id", using: :btree
    t.index ["order_id"], name: "index_order_elements_on_order_id", using: :btree
  end

  create_table "ordered_meals", force: :cascade do |t|
    t.integer  "order_id"
    t.integer  "meal_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "quantity",   default: 1
    t.integer  "option_id"
    t.index ["meal_id"], name: "index_ordered_meals_on_meal_id", using: :btree
    t.index ["option_id"], name: "index_ordered_meals_on_option_id", using: :btree
    t.index ["order_id"], name: "index_ordered_meals_on_order_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "restaurant_id"
    t.integer  "user_rating"
    t.string   "user_comment"
    t.datetime "sent_at"
    t.datetime "ready_at"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "delivered_at"
    t.datetime "located_at"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "preparation_time"
    t.datetime "handled_at"
    t.integer  "payment_method",   default: 0
    t.json     "payment"
    t.integer  "table"
    t.index ["restaurant_id"], name: "index_orders_on_restaurant_id", using: :btree
    t.index ["user_id"], name: "index_orders_on_user_id", using: :btree
  end

  create_table "places", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "photo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "restaurant_categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.string   "address"
    t.boolean  "on_duty",                default: false
    t.string   "shift"
    t.string   "description"
    t.string   "photo"
    t.integer  "user_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.float    "latitude"
    t.float    "longitude"
    t.string   "facebook_url"
    t.integer  "preparation_time",       default: 15
    t.integer  "restaurant_category_id"
    t.string   "about"
    t.integer  "mode",                   default: 0
    t.integer  "messenger_user_id"
    t.string   "messenger_pass"
    t.float    "fb_overall_star_rating"
    t.integer  "fb_fan_count"
    t.integer  "fb_rating_count"
    t.string   "fb_price_range"
    t.bigint   "fb_page_id"
    t.string   "deliveroo_url"
    t.string   "ubereats_url"
    t.string   "foodora_url"
    t.index ["messenger_user_id"], name: "index_restaurants_on_messenger_user_id", using: :btree
    t.index ["restaurant_category_id"], name: "index_restaurants_on_restaurant_category_id", using: :btree
    t.index ["user_id"], name: "index_restaurants_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                       default: "", null: false
    t.string   "encrypted_password",          default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",               default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "messenger_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "facebook_picture_url"
    t.string   "token"
    t.datetime "token_expiry"
    t.string   "facebook_picture_check"
    t.string   "messenger_aline_id"
    t.string   "stripe_customer_id"
    t.integer  "role",                        default: 0
    t.string   "stripe_default_source_brand"
    t.string   "stripe_default_source_last4"
    t.string   "messenger_locale"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "votes", force: :cascade do |t|
    t.string   "votable_type"
    t.integer  "votable_id"
    t.string   "voter_type"
    t.integer  "voter_id"
    t.boolean  "vote_flag"
    t.string   "vote_scope"
    t.integer  "vote_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope", using: :btree
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope", using: :btree
  end

  add_foreign_key "meal_categories", "restaurants"
  add_foreign_key "meal_options", "meals"
  add_foreign_key "meal_options", "options"
  add_foreign_key "meals", "meal_categories"
  add_foreign_key "menu_meal_categories", "meal_categories"
  add_foreign_key "menu_meal_categories", "menus"
  add_foreign_key "menus", "restaurants"
  add_foreign_key "options", "restaurants"
  add_foreign_key "order_elements", "orders"
  add_foreign_key "ordered_meals", "meals"
  add_foreign_key "ordered_meals", "options"
  add_foreign_key "ordered_meals", "orders"
  add_foreign_key "orders", "restaurants"
  add_foreign_key "orders", "users"
  add_foreign_key "restaurants", "restaurant_categories"
  add_foreign_key "restaurants", "users"
  add_foreign_key "restaurants", "users", column: "messenger_user_id"
end
