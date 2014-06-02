class CreateChefs < ActiveRecord::Migration
  def change
    create_table :chefs do |t|
      t.string :name, null: false
      t.string :position, null: false
      t.string :facebook
      t.string :twitter
      t.string :pinterest
      t.string :plus
      t.integer :created_by, null: false
      t.integer :updated_by, null: true
      t.timestamps
    end

    add_index :chefs, :name, unique: true
    add_foreign_key :chefs, :users, column: :created_by
    add_foreign_key :chefs, :users, column: :updated_by
  end
end