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

ActiveRecord::Schema.define(version: 20140805021431) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "hstore"

  create_table "cart_items", force: true do |t|
    t.string   "type",           null: false
    t.integer  "cart_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.integer  "price_id"
    t.integer  "first_half_id"
    t.integer  "second_half_id"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cart_items_products", id: false, force: true do |t|
    t.integer "cart_item_id", null: false
    t.integer "product_id"
  end

  create_table "cart_items_subtractions", id: false, force: true do |t|
    t.integer "cart_item_id", null: false
    t.integer "product_id"
  end

  create_table "carts", force: true do |t|
    t.integer  "status",      default: 0, null: false
    t.integer  "customer_id",             null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pick_up_id"
  end

  create_table "categories", force: true do |t|
    t.string   "name",       null: false
    t.integer  "created_by", null: false
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree

  create_table "categories_categories", id: false, force: true do |t|
    t.integer "category_id", null: false
    t.integer "item_id",     null: false
  end

  create_table "categories_products", id: false, force: true do |t|
    t.integer "category_id", null: false
    t.integer "product_id",  null: false
  end

  create_table "chefs", force: true do |t|
    t.string   "name",                    null: false
    t.string   "position",                null: false
    t.string   "facebook"
    t.string   "twitter"
    t.string   "pinterest"
    t.string   "plus"
    t.integer  "created_by",              null: false
    t.integer  "updated_by"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "background_file_name"
    t.string   "background_content_type"
    t.integer  "background_file_size"
    t.datetime "background_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "chefs", ["name"], name: "index_chefs_on_name", unique: true, using: :btree

  create_table "customers", force: true do |t|
    t.string   "email",                              null: false
    t.string   "encrypted_password",                 null: false
    t.string   "name",                               null: false
    t.string   "surname",                            null: false
    t.string   "mobile",                             null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0, null: false
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

  create_table "order_items", force: true do |t|
    t.string   "type",           null: false
    t.integer  "order_id"
    t.integer  "product_id"
    t.integer  "quantity"
    t.integer  "size_id"
    t.decimal  "unit_price"
    t.decimal  "price"
    t.integer  "first_half_id"
    t.integer  "second_half_id"
    t.text     "notes"
    t.hstore   "properties"
    t.hstore   "additions"
    t.hstore   "subtractions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.integer  "customer_id",              null: false
    t.integer  "pick_up_id",               null: false
    t.decimal  "price",                    null: false
    t.integer  "state"
    t.inet     "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "code",        default: "", null: false
    t.integer  "attempts",    default: 0,  null: false
  end

  add_index "orders", ["customer_id"], name: "index_orders_on_customer_id", using: :btree
  add_index "orders", ["pick_up_id"], name: "index_orders_on_pick_up_id", using: :btree

  create_table "payments", force: true do |t|
    t.integer  "order_id",            null: false
    t.string   "status",              null: false
    t.string   "code",                null: false
    t.string   "description",         null: false
    t.string   "bank_transaction_id"
    t.datetime "bank_settdate"
    t.string   "card_number",         null: false
    t.string   "card_expirydate",     null: false
    t.datetime "timestamp",           null: false
    t.string   "fingerprint",         null: false
    t.inet     "ip_address",          null: false
    t.text     "full_request",        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "payments", ["order_id"], name: "index_payments_on_order_id", using: :btree

  create_table "pick_ups", force: true do |t|
    t.integer  "place_id",   null: false
    t.datetime "date",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "places", force: true do |t|
    t.string   "name",                            null: false
    t.string   "address",                         null: false
    t.string   "phone",                           null: false
    t.string   "description"
    t.text     "map"
    t.integer  "created_by",                      null: false
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "code",               default: "", null: false
    t.boolean  "enabled"
  end

  add_index "places", ["name"], name: "index_places_on_name", unique: true, using: :btree

  create_table "prices", force: true do |t|
    t.integer  "product_id",                         null: false
    t.integer  "size_id",                            null: false
    t.decimal  "value",      precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_types", force: true do |t|
    t.boolean  "shoppable",              default: false, null: false
    t.string   "name",                                   null: false
    t.boolean  "sizable",                                null: false
    t.boolean  "additionable",                           null: false
    t.integer  "created_by",                             null: false
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "itemable",               default: false, null: false
    t.integer  "max_additions"
    t.integer  "max_additions_per_half"
  end

  add_index "product_types", ["name"], name: "index_product_types_on_name", unique: true, using: :btree

  create_table "products", force: true do |t|
    t.boolean  "enabled",                                             default: true, null: false
    t.string   "name",                                                               null: false
    t.string   "description"
    t.decimal  "price",                       precision: 4, scale: 2
    t.integer  "product_type_id",                                                    null: false
    t.integer  "created_by",                                                         null: false
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.string   "photo_left_file_name"
    t.string   "photo_left_content_type"
    t.integer  "photo_left_file_size"
    t.datetime "photo_left_updated_at"
    t.string   "photo_right_file_name"
    t.string   "photo_right_content_type"
    t.integer  "photo_right_file_size"
    t.datetime "photo_right_updated_at"
    t.string   "photo_showcase_file_name"
    t.string   "photo_showcase_content_type"
    t.integer  "photo_showcase_file_size"
    t.datetime "photo_showcase_updated_at"
  end

  add_index "products", ["name"], name: "index_products_on_name", unique: true, using: :btree

  create_table "products_products", id: false, force: true do |t|
    t.integer "product_id", null: false
    t.integer "item_id",    null: false
  end

  create_table "shifts", force: true do |t|
    t.integer  "opening_hour_id", null: false
    t.time     "start_at",        null: false
    t.time     "end_at",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sizes", force: true do |t|
    t.string   "name",                        null: false
    t.string   "description"
    t.string   "string"
    t.integer  "created_by",                  null: false
    t.integer  "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "splittable",  default: false, null: false
  end

  add_index "sizes", ["name"], name: "index_sizes_on_name", unique: true, using: :btree

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

  add_foreign_key "cart_items_products", "cart_items", name: "cart_items_products_cart_item_id_fk"
  add_foreign_key "cart_items_products", "products", name: "cart_items_products_product_id_fk"

  add_foreign_key "cart_items_subtractions", "cart_items", name: "cart_items_subtractions_cart_item_id_fk"
  add_foreign_key "cart_items_subtractions", "products", name: "cart_items_subtractions_product_id_fk"

  add_foreign_key "carts", "customers", name: "carts_customer_id_fk"
  add_foreign_key "carts", "pick_ups", name: "carts_pick_up_id_fk"

  add_foreign_key "categories", "users", name: "categories_created_by_fk", column: "created_by"
  add_foreign_key "categories", "users", name: "categories_updated_by_fk", column: "updated_by"

  add_foreign_key "categories_categories", "categories", name: "categories_categories_category_id_fk"
  add_foreign_key "categories_categories", "categories", name: "categories_categories_item_id_fk", column: "item_id"

  add_foreign_key "categories_products", "categories", name: "categories_products_category_id_fk"
  add_foreign_key "categories_products", "products", name: "categories_products_product_id_fk"

  add_foreign_key "chefs", "users", name: "chefs_created_by_fk", column: "created_by"
  add_foreign_key "chefs", "users", name: "chefs_updated_by_fk", column: "updated_by"

  add_foreign_key "opening_hours", "places", name: "opening_hours_place_id_fk"
  add_foreign_key "opening_hours", "users", name: "opening_hours_created_by_fk", column: "created_by"
  add_foreign_key "opening_hours", "users", name: "opening_hours_updated_by_fk", column: "updated_by"

  add_foreign_key "order_items", "order_items", name: "order_items_first_half_id_fk", column: "first_half_id"
  add_foreign_key "order_items", "order_items", name: "order_items_second_half_id_fk", column: "second_half_id"
  add_foreign_key "order_items", "orders", name: "order_items_order_id_fk"
  add_foreign_key "order_items", "products", name: "order_items_product_id_fk"
  add_foreign_key "order_items", "sizes", name: "order_items_size_id_fk"

  add_foreign_key "orders", "customers", name: "orders_customer_id_fk"
  add_foreign_key "orders", "pick_ups", name: "orders_pick_up_id_fk"

  add_foreign_key "payments", "orders", name: "payments_order_id_fk"

  add_foreign_key "pick_ups", "places", name: "pick_ups_place_id_fk"

  add_foreign_key "places", "users", name: "places_created_by_fk", column: "created_by"
  add_foreign_key "places", "users", name: "places_updated_by_fk", column: "updated_by"

  add_foreign_key "prices", "products", name: "prices_product_id_fk"
  add_foreign_key "prices", "sizes", name: "prices_size_id_fk"

  add_foreign_key "product_types", "users", name: "product_types_created_by_fk", column: "created_by"
  add_foreign_key "product_types", "users", name: "product_types_updated_by_fk", column: "updated_by"

  add_foreign_key "products", "product_types", name: "products_product_type_id_fk"
  add_foreign_key "products", "users", name: "products_created_by_fk", column: "created_by"
  add_foreign_key "products", "users", name: "products_updated_by_fk", column: "updated_by"

  add_foreign_key "products_products", "products", name: "products_products_item_id_fk", column: "item_id"
  add_foreign_key "products_products", "products", name: "products_products_product_id_fk"

  add_foreign_key "shifts", "opening_hours", name: "shifts_opening_hour_id_fk"

  add_foreign_key "sizes", "users", name: "sizes_created_by_fk", column: "created_by"
  add_foreign_key "sizes", "users", name: "sizes_updated_by_fk", column: "updated_by"

end
