FactoryGirl.define do

  factory :sponsor_type do
    name {Faker::Commerce.color}
    description {Faker::Company.catch_phrase}
    display_rank [*1..100].sample
  end

  factory :sponsor do
    sequence(:name) { |n| Faker::Company.name + " #{n}"}
    description {Faker::Lorem.sentence(10)}
    sponsor_type {create(:sponsor_type)}
    logo 'www.example.com/sponsor_logo.jpg'
    url {Faker::Internet.domain_name}

    trait :event do
      event {create(:event, :random)}
    end

    trait :group do
      group {create(:group, :random)}
    end
  end

  factory :sponsor_user do
    user {create(:user, :random)}
    sponsor {create(:sponsor)}
  end

  factory :banner_ad do
    graphic_link 'www.example.com/graphic_link.jpg'
    link_url 'www.example.com'

    trait :sponsor do
      sponsor {create(:sponsor)}
    end
  end
  
  factory :sponsor_attachment do
    sequence(:url) { |n| "www.example#{n}.com" }

    trait :sponsor do
      sponsor {create(:sponsor)}
    end
  end

end
