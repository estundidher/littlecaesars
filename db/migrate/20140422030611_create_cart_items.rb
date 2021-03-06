class CreateCartItems < ActiveRecord::Migration
  def change
    create_table :cart_items do |t|

      t.string :type, null: false

      t.references :cart, null: false
      t.foreign_key :carts

      t.references :product, null: true
      t.foreign_key :products

      t.integer :quantity, null: true

      t.references :price, null: true
      t.foreign_key :prices

      t.integer :first_half_id, null: true
      t.integer :second_half_id, null: true

      t.text :notes, null: true

      t.timestamps
    end

    add_foreign_key :cart_items, :cart_items, column:'first_half_id'
    add_foreign_key :cart_items, :cart_items, column:'second_half_id'
  end
end