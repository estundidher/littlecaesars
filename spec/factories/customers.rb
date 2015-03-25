FactoryGirl.define do

  factory :customer do
    name 'Foo name'
    surname 'Foo surname'
    mobile 'Foo mobile'
    sequence(:email) {|n| "customer#{n}@caesars.com"}
    password 'qazwsx'
    password_confirmation {|u| u.password}
  end
end