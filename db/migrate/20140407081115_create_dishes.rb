class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.string :name
      t.string :description
      t.integer :category_id
      t.foreign_key :categories
      t.timestamps
    end
  end
end