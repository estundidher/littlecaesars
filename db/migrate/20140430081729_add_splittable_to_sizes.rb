class AddSplittableToSizes < ActiveRecord::Migration
  def change
    add_column :sizes, :splittable, :boolean, null: false, default: false
  end
end