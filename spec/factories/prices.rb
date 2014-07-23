FactoryGirl.define do
  factory :price do
    factory :smashing_pumpkins_big_caesars_price do
      association :product, factory: :smashing_pumpkins
      association :size, factory: :big_caesars
      value 22.22
    end
    factory :smashing_pumpkins_little_caesars_price do
      association :product, factory: :smashing_pumpkins
      association :size, factory: :little_caesars
      value 15.00
    end
    factory :smashing_pumpkins_gluten_free_price do
      association :product, factory: :smashing_pumpkins
      association :size, factory: :gluten_free
      value 25.00
    end
  end
end