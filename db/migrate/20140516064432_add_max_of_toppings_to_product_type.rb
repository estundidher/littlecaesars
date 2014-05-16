class AddMaxOfToppingsToProductType < ActiveRecord::Migration
  def change
    add_column :product_types, :max_additions, :integer
    add_column :product_types, :max_additions_per_half, :integer
  end
end