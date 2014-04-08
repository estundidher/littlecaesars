class AddIngredientsToDish < ActiveRecord::Migration
  def change
    create_table :dishes_ingredients do |t|
      t.belongs_to :dish
      t.foreign_key :dishes

      t.belongs_to :ingredient
      t.foreign_key :ingredients
    end
  end
end