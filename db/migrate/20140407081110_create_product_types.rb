class CreateProductTypes < ActiveRecord::Migration
  def change
    create_table :product_types do |t|
      t.boolean :shoppable, null: false, default: 0
      t.string :name, null: false
      t.boolean :sizable, null: false
      t.boolean :additionable, null: false
      t.integer :created_by, null: false
      t.integer :updated_by, null: true
      t.timestamps
    end

    add_index :product_types, :name, unique: true
    add_foreign_key :product_types, :users, column: 'created_by'
    add_foreign_key :product_types, :users, column: 'updated_by'
  end
end