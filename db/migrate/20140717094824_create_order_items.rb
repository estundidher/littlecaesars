class CreateOrderItems < ActiveRecord::Migration
  def change

    enable_extension 'hstore'

    create_table :order_items do |t|

      t.string :type, null:false

      t.references :order, null:true
      t.foreign_key :orders

      t.references :product, null:true
      t.foreign_key :products

      t.integer :quantity, null:true

      t.references :size, null:true
      t.foreign_key :sizes

      t.decimal :unit_price, null:true
      t.decimal :price, null:true

      t.integer :first_half_id, null:true
      t.integer :second_half_id, null:true

      t.text :notes, null:true

      t.hstore :properties, null:true
      t.hstore :additions, null:true
      t.hstore :subtractions, null:true

      t.timestamps
    end

    add_foreign_key :order_items, :order_items, column:'first_half_id'
    add_foreign_key :order_items, :order_items, column:'second_half_id'
  end
end