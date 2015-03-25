class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.belongs_to :opening_hour, null: false
      t.foreign_key :opening_hours
      t.time :start_at, null: false
      t.time :end_at, null: false
      t.timestamps
    end
  end
end