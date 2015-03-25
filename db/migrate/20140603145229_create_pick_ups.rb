class CreatePickUps < ActiveRecord::Migration
  def change
    create_table :pick_ups do |t|
      t.integer :place_id, null: false
      t.datetime :date, null: false
      t.timestamps
    end
    add_foreign_key :pick_ups, :places

    add_column :carts, :pick_up_id, :integer
    add_foreign_key :carts, :pick_ups
  end
end