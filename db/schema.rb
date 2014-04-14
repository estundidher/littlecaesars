# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140414043139) do

  create_table "categories", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dishes", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "dishes", ["category_id"], name: "dishes_category_id_fk", using: :btree

  create_table "dishes_ingredients", force: true do |t|
    t.integer "dish_id"
    t.integer "ingredient_id"
  end

  add_index "dishes_ingredients", ["dish_id"], name: "dishes_ingredients_dish_id_fk", using: :btree
  add_index "dishes_ingredients", ["ingredient_id"], name: "dishes_ingredients_ingredient_id_fk", using: :btree

  create_table "ingredients", force: true do |t|
    t.string   "name"
    t.decimal  "price",               precision: 4, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  create_table "opening_hours", force: true do |t|
    t.integer  "place_id"
    t.string   "day_of_week"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "opening_hours", ["place_id"], name: "opening_hours_place_id_fk", using: :btree

  create_table "places", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "description"
    t.text     "map"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  create_table "prices", force: true do |t|
    t.integer  "dish_id"
    t.integer  "size_id"
    t.decimal  "value",      precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["dish_id"], name: "prices_dish_id_fk", using: :btree
  add_index "prices", ["size_id"], name: "prices_size_id_fk", using: :btree

  create_table "shifts", force: true do |t|
    t.integer  "opening_hour_id"
    t.time     "start_at"
    t.time     "end_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shifts", ["opening_hour_id"], name: "shifts_opening_hour_id_fk", using: :btree

  create_table "sizes", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "username",               default: "",    null: false
    t.string   "string",                 default: "",    null: false
    t.boolean  "admin",                  default: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "dishes", "categories", name: "dishes_category_id_fk"

  add_foreign_key "dishes_ingredients", "dishes", name: "dishes_ingredients_dish_id_fk"
  add_foreign_key "dishes_ingredients", "ingredients", name: "dishes_ingredients_ingredient_id_fk"

  add_foreign_key "opening_hours", "places", name: "opening_hours_place_id_fk"

  add_foreign_key "prices", "dishes", name: "prices_dish_id_fk"
  add_foreign_key "prices", "sizes", name: "prices_size_id_fk"

  add_foreign_key "shifts", "opening_hours", name: "shifts_opening_hour_id_fk"

end
