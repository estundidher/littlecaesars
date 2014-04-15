class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.belongs_to :user, null: false
      t.foreign_key :users
      t.timestamps
    end
  end
end