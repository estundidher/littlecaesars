include ActionDispatch::TestProcess

FactoryGirl.define do

  factory :product do

    created_at {Date.current}
    created_by
    photo_showcase {fixture_file_upload 'spec/files/product.jpg', 'image/jpg'}

    factory :cream_sauce do
      association :type, factory: :ingredient
      name 'Cream Sauce'
      price 0.70
      after :build do |product, evaluator|
        product.categories << build(:vegetarian)
      end
      after :stub do |product, evaluator|
        product.categories << build_stubbed(:vegetarian)
      end
    end

    factory :avocado do
      association :type, factory: :ingredient
      name 'Avocado'
      price 2.00
      after :build do |product, evaluator|
        product.categories << build(:vegetarian)
      end
      after :stub do |product, evaluator|
        product.categories << build_stubbed(:vegetarian)
      end
    end

    factory :smashing_pumpkins do
      association :type, factory: :pizza
      name 'Smashing Pumpkins'
      description 'Roasted pumpkin, cashews, mozzarella, parmesan, cream sauce, garlic, parsley'
      after :build do |product, evaluator|
        product.categories << build(:vegetarian)
        product.items << [build(:cream_sauce), build(:avocado)]
      end
      after :stub do |product, evaluator|
        product.categories << build_stubbed(:vegetarian)
        product.items << [build_stubbed(:cream_sauce), build_stubbed(:avocado)]
      end
    end
  end
end