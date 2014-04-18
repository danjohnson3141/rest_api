FactoryGirl.define do

  factory :post do

    body 'Body text.'
    creator { create(:user, :random) }

    trait :random do
      title { Faker::Company.catch_phrase + ': ' + Faker::Commerce.product_name }
      body { Faker::Lorem.paragraphs(2) }
      body_markdown { Faker::Lorem.paragraphs(2) }
      excerpt { Faker::Company.catch_phrase }
      thumbnail_teaser_photo 'www.example.com/post_thumbnail.jpg'
      display_rank { rand(10) }
      view_count { rand(10) }
    end

    trait :group do
      group { create(:group, :random) }
    end

    trait :event do
      event { create(:event, :random) }
    end

    trait :event_session do
      session { create(:event_session)}
    end

  end

  factory :featured_post do
    trait :random do
      post { create(:post, :random, :event) }
    end
  end

  factory :post_comment do
    trait :random do
      post { create(:post, :random, event: create(:event, :random)) }
      body { Faker::Company.catch_phrase }
    end
    trait :random_group do
      post { create(:post, :random, :group)}
      body { Faker::Company.catch_phrase }
    end
  end

  factory :post_like do
    trait :random do
      post { create(:post, :random, event: create(:event, :random) )}
      user { create(:user, :random)}
    end
  end

  factory :post_contributor
  factory :post_attachment
  factory :post_follower

end
