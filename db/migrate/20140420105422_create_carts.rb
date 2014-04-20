class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.integer :status, null: false, default: 0
      t.belongs_to :customer, null: false
      t.foreign_key :customers
      t.timestamps
    end
  end
end