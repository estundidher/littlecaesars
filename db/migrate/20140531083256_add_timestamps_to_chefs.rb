class AddTimestampsToChefs < ActiveRecord::Migration
  change_table :chefs do |t|
    t.timestamps
  end
end