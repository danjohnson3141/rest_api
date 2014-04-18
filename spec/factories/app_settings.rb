FactoryGirl.define do

  factory :app_setting_option


  factory :app_setting do
    app_setting_option nil
    event nil
    group nil
    user_role nil
    user nil
  end

  factory :app_setting_type do
    id 1
    name "MyString"
    description "MyString"
  end

  factory :app_setting_dependency do
    id 1
  end

end