class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.integer :created_by, null: false
      t.integer :updated_by, null: true
      t.timestamps
    end

    add_index :categories, :name, unique: true
    add_foreign_key :categories, :users, column: 'created_by'
    add_foreign_key :categories, :users, column: 'updated_by'
  end
end