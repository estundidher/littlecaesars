FactoryGirl.define do

  factory :pick_up do
    cart
    association :place, factory: :hillarys
    date {Date.current}
    after :stub do |pick_up, evaluator|
      pick_up.id = nil
    end
  end
end