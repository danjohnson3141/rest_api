def find_or_create_event_registration_status(key)
  event_registration_status = EventRegistrationStatus.where(key: key).first
  return event_registration_status unless event_registration_status.nil?
  create(:event_registration_status, key.to_sym)
end

FactoryGirl.define do

  factory :event do
    begin_date  { Time.now - 1.days }
    end_date  { Time.now + 1.days }

    trait :random do
      sequence(:name) { |n| Faker::Commerce.product_name + " #{n}"}
      venue_name {Faker::Company.name}
      address {Faker::Address.street_address}
      state {Faker::Address.state_abbr}
      postal_code {Faker::Address.zip_code}
      country { create(:country, :random)}
      group { create(:group, :random, :open) }
      timezone { create(:timezone, :pacific)}
      begin_date  { Time.now + 10.days }
      end_date  { Time.now + 11.days }
    end

    trait :past do
      begin_date  { Time.now - 4.days }
      end_date  { Time.now - 3.days }
    end

    trait :today do
      begin_date  { Time.now }
      end_date  { Time.now }
    end

    trait :future do
      begin_date  { Time.now + 10.days }
      end_date  { Time.now + 11.days }
    end

    trait :open do
      group { create(:group, :random, :open) }
    end    

    trait :private do
      group { create(:group, :random, :private) }
    end    

    trait :secret do
      group { create(:group, :random, :secret) }
    end

  end

  factory :event_follower

  factory :event_user do

    event_registration_status { EventRegistrationStatus.find_by_key('invited') }

    trait :invited do
      event_registration_status { EventRegistrationStatus.find_by_key('invited') }
    end

    trait :registered do
      event_registration_status { EventRegistrationStatus.find_by_key('registered') }
    end

    trait :attended do
      event_registration_status { EventRegistrationStatus.find_by_key('attended') }
    end

  end

  factory :event_session do
    name {Faker::Commerce.product_name}
    description { Faker::Company.catch_phrase + '. ' + Faker::Company.catch_phrase }
    start_date_time { Time.now }
    end_date_time { Time.now + 1.hours }
    track_name { Faker::Company.catch_phrase }
    session_type { Faker::Commerce.product_name }
    room_name { Faker::Commerce.product_name }
    sponsor { create(:sponsor) }
    display_rank [*1..100].sample
    event { create(:event, :random)}

    trait :random do   
      name {Faker::Commerce.product_name}
      description { Faker::Company.catch_phrase + '. ' + Faker::Company.catch_phrase }
      start_date_time { Time.now }
      end_date_time { Time.now + 1.hours }
      track_name { Faker::Company.catch_phrase }
      session_type { Faker::Commerce.product_name }
      room_name { Faker::Commerce.product_name }
      sponsor { create(:sponsor) }
      display_rank [*1..100].sample
      event { create(:event, :random)}
    end

  end

  factory :event_speaker do
    trait :random do
      first_name {Faker::Name.first_name}
      last_name {Faker::Name.last_name}
      title {Faker::Commerce.product_name}
      organization_name {Faker::Company.name}
      bio {Faker::Lorem.paragraph(3) + "\n\n" + Faker::Lorem.paragraph(2)}
      speaker_type {Faker::Commerce.product_name}
      moderator { [true, false].sample }
      user { create(:user, :random) }
      event_session { create(:event_session, :random) }
    end
  end

  factory :event_note do
    trait :random do
      body {Faker::Lorem.paragraph(3) + "\n\n" + Faker::Lorem.paragraph(2)}
    end

    trait :user do
      event_user { create(:event_user, :registered)}
    end

    trait :speaker do
      event_speaker { create(:event_speaker, :random)}
    end

    trait :session do
      event_session { create(:event_session, :random)}
    end

    trait :sponsor do
      sponsor { create(:sponsor, :random)}
    end

  end

  factory :event_bookmark do
    trait :speaker do
      event_speaker { create(:event_speaker, :random)}
    end

    trait :sponsor do
      sponsor { create(:sponsor, :random)}
    end

    trait :session do
      event_session { create(:event_session, :random)}
    end
  end

  factory :event_user_schedule

  factory :event_staff_user

  factory :event_session_evaluation

  factory :event_evaluation do
    name {Faker::Commerce.product_name}
    display_rank [*1..100].sample
    user_role { UserRole.find_by_name('User_all') }

    trait :guest do
      user_role { UserRole.find_by_name('Guest') }
    end    

    trait :user_all do
      user_role { UserRole.find_by_name('User_all') }
    end    

    trait :member do
      user_role { UserRole.find_by_name('Member') }
    end    

    trait :sponsor do
      user_role { UserRole.find_by_name('Sponsor') }
    end    

    trait :former do
      user_role { UserRole.find_by_name('Former') }
    end
 
  end

end
