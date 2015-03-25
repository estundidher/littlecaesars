class ChangeFullRequestTypeAtPayments < ActiveRecord::Migration
  def change
    change_column :payments, :full_request, :text, limit:nil
  end
end