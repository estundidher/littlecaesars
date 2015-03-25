class CreateOpeningHours < ActiveRecord::Migration
  def change
    create_table :opening_hours do |t|
      t.belongs_to :place, null: false
      t.foreign_key :places
      t.string :day_of_week, null: false
      t.integer :created_by, null: false
      t.integer :updated_by, null: true
      t.timestamps
    end

    add_foreign_key :opening_hours, :users, column: 'created_by'
    add_foreign_key :opening_hours, :users, column: 'updated_by'
  end
end