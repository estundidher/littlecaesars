FactoryGirl.define do

  factory :admin, class:User, aliases: [:created_by] do
    sequence(:username) { |n| "admin#{n}" }
    sequence(:email) {|n| "admin#{n}@caesars.com"}
    password 'qazwsx'
    password_confirmation {|u| u.password}
  end

end