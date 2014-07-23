class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|

      t.references :customer, index: true, null:false
      t.foreign_key :customers

      t.references :pick_up, index: true, null:false
      t.foreign_key :pick_ups

      t.decimal :price, null:false
      t.integer :state
      t.inet :ip_address
      t.timestamps
    end
  end
end