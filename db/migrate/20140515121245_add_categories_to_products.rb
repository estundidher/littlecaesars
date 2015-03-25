class AddCategoriesToProducts < ActiveRecord::Migration
  def change
    create_table :categories_products, id: false do |t|
      t.belongs_to :category, null: false
      t.foreign_key :categories
      t.belongs_to :product, null: false
      t.foreign_key :products
    end
  end
end