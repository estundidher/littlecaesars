class AddStatusToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :status, :integer, null:true, default:nil
  end
end