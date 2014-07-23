# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :payment do
    order nil
    status "MyString"
    code "MyString"
    description "MyString"
    transaction_id "MyString"
    settdate "2014-07-23"
    card_number "MyString"
    expirydate "MyString"
    timestamp "MyString"
    fingerprint "MyString"
  end
end
