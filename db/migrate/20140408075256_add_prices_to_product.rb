class AddPricesToProduct < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.belongs_to :product, null: false
      t.foreign_key :products
      t.belongs_to :size, null: false
      t.foreign_key :sizes
      t.decimal :value, precision: 5, scale: 2
      t.timestamps
    end
  end
end