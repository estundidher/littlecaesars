FactoryGirl.define do

  factory :place do

    created_at { Date.current }
    created_by

    factory :hillarys do
      name 'Hillarys'
      address 'Shop 221, Sorrento Quay Hillarys Boat Harbour Sorrento WA 6020'
      phone '(08) 9444 0499'
      description 'Booking: Not available, but our waiter/ess will find a table for you'
    end

    factory :mundaring do
      name 'Mundaring'
      address '7125 Grt Eastern Hwy Mundaring WA 6073'
      phone '(08) 9444 0499'
      description 'Booking: Not available, but our waiter/ess will find a table for you'
    end

    factory :leederville do
      name 'Leederville'
      address '7125 Grt Eastern Hwy Mundaring WA 6073'
      phone '(08) 9444 0499'
      description 'Booking: Not available, but our waiter/ess will find a table for you'
    end
  end
end