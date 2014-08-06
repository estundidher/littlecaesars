class AddEnabledToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :enabled, :boolean
  end
end