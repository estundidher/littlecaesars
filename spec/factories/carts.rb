FactoryGirl.define do

  factory :cart do
    customer
    status :open
  end
end