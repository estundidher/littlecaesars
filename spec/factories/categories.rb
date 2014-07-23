FactoryGirl.define do

  factory :category do
    created_at { Date.current }
    created_by
    factory :vegetarian do
      name 'Vegetarian'
    end
    factory :chicken do
      name 'Chicken'
    end
  end
end