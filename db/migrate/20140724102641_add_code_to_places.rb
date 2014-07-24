class AddCodeToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :code, :string, null:false, default: ''
    add_column :orders, :code, :string, null:false, default: ''
  end
end