class CreatePlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.string :name, null: false
      t.string :address, null: false
      t.string :phone, null: false
      t.string :description
      t.text   :map
      t.integer :created_by, null: false
      t.integer :updated_by, null: true
      t.timestamps
    end

    add_index :places, :name, unique: true
    add_foreign_key :places, :users, column: 'created_by'
    add_foreign_key :places, :users, column: 'updated_by'
  end
end