FactoryBot.define do
  factory :item do
    name { Faker::Food.dish }
    description { Faker::Lorem.paragraph }
    unit_price { Faker::Number.decimal(l_digits: 2) }
    merchant
  end
end
