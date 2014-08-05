class AddAbnAndPrinterIpToPlaces < ActiveRecord::Migration
  def change
    add_column :places, :abn, :string
    add_column :places, :printer_ip, :inet
    add_column :places, :printer_name, :string
  end
end