class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :description
      t.text   :map

      t.timestamps
    end
  end
end