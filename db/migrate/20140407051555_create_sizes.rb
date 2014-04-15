class CreateSizes < ActiveRecord::Migration
  def change
    create_table :sizes do |t|
      t.string :name, null: false
      t.string :description, :string
      t.integer :created_by, null: false
      t.integer :updated_by, null: true
      t.timestamps
    end

    add_index :sizes, :name, unique: true
    add_foreign_key :sizes, :users, column: 'created_by'
    add_foreign_key :sizes, :users, column: 'updated_by'
  end
end