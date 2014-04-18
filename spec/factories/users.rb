FactoryGirl.define do

  factory :user do
    email "generic_user@evanta.com"
    first_name "Generic"
    last_name "User"
    password "evanta2014"
    title "CEO of QA"
    organization_name "Evanta"
    authentication_token 54321
    photo "https://assets.evanta.com/shared/resources/Users/large/anonymous2.jpg"
    app_language_id 1
    bio "This is the biography of the default Generic User"
    user_role { UserRole.find_by_name('User_all') }

    trait :bluehawk do
      email "bluehawk@evanta.com"
      first_name "BlueHawk"
      last_name "TestUser"
      authentication_token 65432
    end

    trait :creator1 do
      email {Faker::Internet.email}
      first_name {Faker::Name.first_name}
      last_name {Faker::Name.last_name}
      authentication_token {SecureRandom.urlsafe_base64(nil, false)}
      password 'evanta2014'
      title 'Creator Of All 1'
      organization_name {Faker::Company.name}
      bio {Faker::Lorem.sentence(10)}
    end

    trait :random do
      email {Faker::Internet.email}
      authentication_token {SecureRandom.urlsafe_base64(nil, false)}
      first_name {Faker::Name.first_name}
      last_name {Faker::Name.last_name}
      title 'Random User'
      organization_name {Faker::Company.name}
      bio {Faker::Lorem.sentence(10)}
    end

    trait :group_owner do
      email {Faker::Internet.email}
      authentication_token {SecureRandom.urlsafe_base64(nil, false)}
      first_name "Group"
      last_name "Owner"
      title 'Group Owner'
      organization_name {Faker::Company.name}
      bio {Faker::Lorem.sentence(10)}
    end

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

  factory :user_role do

    # trait :random do
    #   name {Faker::Commerce.department}
    # end  

    # trait :user_all do
    #   name "User_all"
    # end  

    # trait :guest do
    #   name "Guest"
    # end  

    # trait :member do
    #   name "Member"
    # end

    # trait :sponsor do
    #   name "Sponsor"
    # end

    # trait :former do
    #   name "Former"
    # end

  end

  factory :user_connection do

      trait :pending do
        is_approved false
      end      

      trait :approved do
        is_approved true
      end
  end

end
