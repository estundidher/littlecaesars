class AddNullToOrderAtOrderItems < ActiveRecord::Migration
  def change
    change_column_null(:order_items, :order_id, true)
  end
end