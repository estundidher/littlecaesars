class AddAdditionsAndSubtractionsToCartItems < ActiveRecord::Migration

  def change

    create_table :cart_items_subtractions, id: false do |t|
      t.belongs_to :cart_item, null: false
      t.foreign_key :cart_items

      t.belongs_to :product, null: true
      t.foreign_key :products
    end
  end
end