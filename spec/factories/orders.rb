FactoryGirl.define do

  factory :order do
    customer
    pick_up
    state 1
    ip_address '192.168.1.1'
  end
end