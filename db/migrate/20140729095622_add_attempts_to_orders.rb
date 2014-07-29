class AddAttemptsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :attempts, :integer, null:false, default:0
  end
end