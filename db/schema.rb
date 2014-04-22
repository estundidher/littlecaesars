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

ActiveRecord::Schema.define(version: 20140422030611) do

  create_table "cart_items", force: true do |t|
    t.string   "type",           null: false
    t.integer  "cart_id",        null: false
    t.integer  "product_id"
    t.integer  "quantity"
    t.integer  "price_id"
    t.integer  "first_half_id"
    t.integer  "second_half_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cart_items", ["cart_id"], name: "cart_items_cart_id_fk", using: :btree
  add_index "cart_items", ["first_half_id"], name: "cart_items_first_half_id_fk", using: :btree
  add_index "cart_items", ["price_id"], name: "cart_items_price_id_fk", using: :btree
  add_index "cart_items", ["product_id"], name: "cart_items_product_id_fk", using: :btree
  add_index "cart_items", ["second_half_id"], name: "cart_items_second_half_id_fk", using: :btree

  create_table "carts", force: true do |t|
    t.integer  "status",      default: 0, null: false
    t.integer  "customer_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "carts", ["customer_id"], name: "carts_customer_id_fk", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name",       null: false
    t.integer  "created_by", null: false
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["created_by"], name: "categories_created_by_fk", using: :btree
  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree
  add_index "categories", ["updated_by"], name: "categories_updated_by_fk", using: :btree

  create_table "customers", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "name",                                null: false
    t.string   "surname",                             null: false
    t.string   "mobile",                              null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "customers", ["email"], name: "index_customers_on_email", unique: true, using: :btree
  add_index "customers", ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true, using: :btree

  create_table "opening_hours", force: true do |t|
    t.integer  "place_id",    null: false
    t.string   "day_of_week", null: false
    t.integer  "created_by",  null: false
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "opening_hours", ["created_by"], name: "opening_hours_created_by_fk", using: :btree
  add_index "opening_hours", ["place_id"], name: "opening_hours_place_id_fk", using: :btree
  add_index "opening_hours", ["updated_by"], name: "opening_hours_updated_by_fk", using: :btree

  create_table "places", force: true do |t|
    t.string   "name",               null: false
    t.string   "address",            null: false
    t.string   "phone",              null: false
    t.string   "description"
    t.text     "map"
    t.integer  "created_by",         null: false
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "places", ["created_by"], name: "places_created_by_fk", using: :btree
  add_index "places", ["name"], name: "index_places_on_name", unique: true, using: :btree
  add_index "places", ["updated_by"], name: "places_updated_by_fk", using: :btree

  create_table "prices", force: true do |t|
    t.integer  "product_id",                         null: false
    t.integer  "size_id",                            null: false
    t.decimal  "value",      precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["product_id"], name: "prices_product_id_fk", using: :btree
  add_index "prices", ["size_id"], name: "prices_size_id_fk", using: :btree

  create_table "product_types", force: true do |t|
    t.string   "name",         null: false
    t.boolean  "sizable",      null: false
    t.boolean  "additionable", null: false
    t.integer  "created_by",   null: false
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_types", ["created_by"], name: "product_types_created_by_fk", using: :btree
  add_index "product_types", ["name"], name: "index_product_types_on_name", unique: true, using: :btree
  add_index "product_types", ["updated_by"], name: "product_types_updated_by_fk", using: :btree

  create_table "products", force: true do |t|
    t.string   "name",                                       null: false
    t.string   "description"
    t.decimal  "price",              precision: 4, scale: 2
    t.integer  "product_type_id",                            null: false
    t.integer  "category_id",                                null: false
    t.integer  "created_by",                                 null: false
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

  add_index "products", ["category_id"], name: "products_category_id_fk", using: :btree
  add_index "products", ["created_by"], name: "products_created_by_fk", using: :btree
  add_index "products", ["name"], name: "index_products_on_name", unique: true, using: :btree
  add_index "products", ["product_type_id"], name: "products_product_type_id_fk", using: :btree
  add_index "products", ["updated_by"], name: "products_updated_by_fk", using: :btree

  create_table "products_products", id: false, force: true do |t|
    t.integer "product_id", null: false
    t.integer "item_id",    null: false
  end

  add_index "products_products", ["item_id"], name: "product_items_item_id_fk", using: :btree
  add_index "products_products", ["product_id"], name: "product_items_product_id_fk", using: :btree

  create_table "shifts", force: true do |t|
    t.integer  "opening_hour_id", null: false
    t.time     "start_at",        null: false
    t.time     "end_at",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shifts", ["opening_hour_id"], name: "shifts_opening_hour_id_fk", using: :btree

  create_table "sizes", force: true do |t|
    t.string   "name",        null: false
    t.string   "description"
    t.string   "string"
    t.integer  "created_by",  null: false
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sizes", ["created_by"], name: "sizes_created_by_fk", using: :btree
  add_index "sizes", ["name"], name: "index_sizes_on_name", unique: true, using: :btree
  add_index "sizes", ["updated_by"], name: "sizes_updated_by_fk", using: :btree

  create_table "users", force: true do |t|
    t.string   "username",               default: "",    null: false
    t.string   "email"
    t.string   "encrypted_password",     default: "",    null: false
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

  add_foreign_key "cart_items", "cart_items", name: "cart_items_first_half_id_fk", column: "first_half_id"
  add_foreign_key "cart_items", "cart_items", name: "cart_items_second_half_id_fk", column: "second_half_id"
  add_foreign_key "cart_items", "carts", name: "cart_items_cart_id_fk"
  add_foreign_key "cart_items", "prices", name: "cart_items_price_id_fk"
  add_foreign_key "cart_items", "products", name: "cart_items_product_id_fk"

  add_foreign_key "carts", "customers", name: "carts_customer_id_fk"

  add_foreign_key "categories", "users", name: "categories_created_by_fk", column: "created_by"
  add_foreign_key "categories", "users", name: "categories_updated_by_fk", column: "updated_by"

  add_foreign_key "opening_hours", "places", name: "opening_hours_place_id_fk"
  add_foreign_key "opening_hours", "users", name: "opening_hours_created_by_fk", column: "created_by"
  add_foreign_key "opening_hours", "users", name: "opening_hours_updated_by_fk", column: "updated_by"

  add_foreign_key "places", "users", name: "places_created_by_fk", column: "created_by"
  add_foreign_key "places", "users", name: "places_updated_by_fk", column: "updated_by"

  add_foreign_key "prices", "products", name: "prices_product_id_fk"
  add_foreign_key "prices", "sizes", name: "prices_size_id_fk"

  add_foreign_key "product_types", "users", name: "product_types_created_by_fk", column: "created_by"
  add_foreign_key "product_types", "users", name: "product_types_updated_by_fk", column: "updated_by"

  add_foreign_key "products", "categories", name: "products_category_id_fk"
  add_foreign_key "products", "product_types", name: "products_product_type_id_fk"
  add_foreign_key "products", "users", name: "products_created_by_fk", column: "created_by"
  add_foreign_key "products", "users", name: "products_updated_by_fk", column: "updated_by"

  add_foreign_key "products_products", "products", name: "product_items_item_id_fk", column: "item_id"
  add_foreign_key "products_products", "products", name: "product_items_product_id_fk"

  add_foreign_key "shifts", "opening_hours", name: "shifts_opening_hour_id_fk"

  add_foreign_key "sizes", "users", name: "sizes_created_by_fk", column: "created_by"
  add_foreign_key "sizes", "users", name: "sizes_updated_by_fk", column: "updated_by"

end
