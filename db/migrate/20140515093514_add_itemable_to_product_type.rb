class AddItemableToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :itemable, :boolean, null: false, default: false
  end
end