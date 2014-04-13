class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|

      t.belongs_to :opening_hour
      t.foreign_key :opening_hours

      t.time :start_at
      t.time :end_at

      t.timestamps
    end
  end
end