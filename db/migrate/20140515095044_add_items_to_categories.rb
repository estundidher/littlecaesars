class AddItemsToCategories < ActiveRecord::Migration
  def change
    create_table :categories_categories, id: false do |t|
      t.belongs_to :category, null: false
      t.foreign_key :categories
      t.integer :item_id, null: false
    end

    add_foreign_key :categories_categories, :categories, column: 'item_id'
  end
end