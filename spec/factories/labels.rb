FactoryGirl.define do

  factory :app_label do
    label "Testing Label Text"
  end

  factory :app_label_page do

    sequence(:name) {|x| "test_page_#{x}"}

    description "Factory Data"
    auth_required false
    
    trait :auth_required do
      auth_required true
    end
  end
  
  factory :app_label_dictionary do
    key {Faker::Name.title}
    sequence(:name) {|x| "ApLaDi_#{x}"}
    app_label_page { create(:app_label_page) }

    trait :auth_required do
      app_label_page { create(:app_label_page, :auth_required) }
    end

  end

end