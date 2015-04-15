FactoryGirl.define do

  factory :size do
    created_by
    created_at { Date.current }

    factory :big_caesars do
      name 'BC'
      description '12 slices/13 inch'
    end

    factory :little_caesars do
      name 'LC'
      description '8 slices/10 inch'
    end

    factory :gluten_free do
      name 'GF'
      description '12 slices/12 inch'
    end
  end
end