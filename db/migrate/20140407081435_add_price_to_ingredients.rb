class AddPriceToIngredients < ActiveRecord::Migration
  def change
    add_column :ingredients, :price, :decimal
  end
end
