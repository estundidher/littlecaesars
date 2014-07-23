class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.references :order, index: true, null:false
      t.foreign_key :orders

      t.string :status, null:false
      t.string :code, null:false
      t.string :description, null:false
      t.string :bank_transaction_id, null:true
      t.datetime :bank_settdate, null:true
      t.string :card_number, null:false
      t.string :card_expirydate, null:false
      t.datetime :timestamp, null:false
      t.string :fingerprint, null:false
      t.inet :ip_address, null:false
      t.string :full_request, null:false

      t.timestamps
    end
  end
end