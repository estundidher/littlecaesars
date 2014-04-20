class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|
      t.belongs_to :cart, null: false
      t.foreign_key :carts
      t.belongs_to :product, null: false
      t.foreign_key :products
      t.integer :quantity, null: false
      t.timestamps
    end
  end
end