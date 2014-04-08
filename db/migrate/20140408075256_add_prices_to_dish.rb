class AddPricesToDish < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.belongs_to :dish
      t.foreign_key :dishes

      t.belongs_to :size
      t.foreign_key :sizes

      t.decimal :value, :precision => 5, :scale => 2
      t.timestamps
    end
  end
end