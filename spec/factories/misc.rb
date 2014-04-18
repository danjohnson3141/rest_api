FactoryGirl.define do

  factory :country do
    name 'Default'

    trait :random do
      name {Faker::Address.country}
      abbreviation {Faker::Lorem.characters(3)}
    end

    trait :us do
      abbreviation 'us'
      name 'United States of America'
    end
  end

  factory :timezone do
    name 'Pacific'
    offset 0

    trait :central do
      name 'Central'
      offset 2
    end

    trait :pacific do
      name 'Pacific'
      offset 2
    end

    trait :london do
      name 'London'
      offset 2
    end

    trait :mountain do
      name 'Mountain'
      offset 2
    end

  end

  factory :notification
  
end
