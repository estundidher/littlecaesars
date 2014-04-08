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

ActiveRecord::Schema.define(version: 20140408075256) do

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

  create_table "prices", force: true do |t|
    t.integer  "dish_id"
    t.integer  "size_id"
    t.decimal  "value",      precision: 5, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "prices", ["dish_id"], name: "prices_dish_id_fk", using: :btree
  add_index "prices", ["size_id"], name: "prices_size_id_fk", using: :btree

  create_table "sizes", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "string"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "dishes", "categories", name: "dishes_category_id_fk"

  add_foreign_key "dishes_ingredients", "dishes", name: "dishes_ingredients_dish_id_fk"
  add_foreign_key "dishes_ingredients", "ingredients", name: "dishes_ingredients_ingredient_id_fk"

  add_foreign_key "prices", "dishes", name: "prices_dish_id_fk"
  add_foreign_key "prices", "sizes", name: "prices_size_id_fk"

end
