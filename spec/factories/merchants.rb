FactoryBot.define do
  factory :merchant do
    name { Faker::Movies::StarWars.character }
  end

  factory :merchant_with_items do
    transient do
      item_count { 2 }
    end
  end
end
