FactoryGirl.define do

  factory :product_type do

    created_at { Date.current }
    created_by

    factory :ingredient do
      name 'Ingredient'
      shoppable false
      sizable false
      additionable false
      max_additions 0
      max_additions_per_half 0
      itemable false
    end

    factory :pizza do
      name 'Pizza'
      shoppable true
      sizable true
      additionable true
      max_additions 6
      max_additions_per_half 3
      itemable true
    end
  end
end