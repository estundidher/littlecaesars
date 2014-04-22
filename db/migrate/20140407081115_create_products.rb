class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.boolean :enabled, null: false, default: 1
      t.string :name, null: false
      t.string :description
      t.decimal :price, precision:4, scale:2
      t.references :product_type, null: false
      t.foreign_key :product_types
      t.references :category, null: false
      t.foreign_key :categories
      t.integer :created_by, null: false
      t.integer :updated_by, null: true
      t.timestamps
    end

    add_index :products, :name, unique: true
    add_foreign_key :products, :users, column: 'created_by'
    add_foreign_key :products, :users, column: 'updated_by'
  end
end