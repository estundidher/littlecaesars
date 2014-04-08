class CreateIngredients < ActiveRecord::Migration
  def change
    create_table :ingredients do |t|
      t.string :name
      t.decimal :price, :precision => 4, :scale => 2
      t.timestamps
    end
  end
end