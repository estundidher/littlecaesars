class AddItemsToProduct < ActiveRecord::Migration
  def change
    create_table :products_products, :id => false do |t|
      t.belongs_to :product, null: false
      t.foreign_key :products
      t.integer :item_id, null: false
    end

    add_foreign_key :products_products, :products, column: 'item_id'
  end
end