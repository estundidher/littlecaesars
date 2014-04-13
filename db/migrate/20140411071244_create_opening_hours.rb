class CreateOpeningHours < ActiveRecord::Migration
  def change
    create_table :opening_hours do |t|

      t.belongs_to :place
      t.foreign_key :places

      t.string :day_of_week

      t.timestamps
    end
  end
end