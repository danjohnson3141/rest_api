FactoryGirl.define do
  
  factory :group do
    name 'TestGroup'
    description 'For Testing'
    group_type { create(:group_type, :open) }
    owner { create(:user, :group_owner) }

    trait :open do
      sequence(:name) { |n| "Open Group #{n}" }
      sequence(:description) { |n| "Open group #{n}" }
      group_type { create(:group_type, :open) }
    end

    trait :private do
      sequence(:name) { |n| "Private Group #{n}" }
      sequence(:description) { |n| "Private group #{n}" }
      group_type { create(:group_type, :private) }
    end 

    trait :secret do
      sequence(:name) { |n| "Secret Group #{n}" }
      sequence(:description) { |n| "Secret group #{n}" }
      group_type { create(:group_type, :secret) }
    end

    trait :random do
      description {Faker::Lorem.sentence(5)}
      sequence(:name) { |n| Faker::Commerce.product_name + " #{n}"}
      created_by {create(:user, :creator1)}
      updated_by {create(:user, :creator1)}
      owner {create(:user, :group_owner)}
    end

  end  

  factory :group_member

  factory :group_type do
   
    trait :open do
      name "Factory:Open"
      description "Open"
      is_group_visible 1
      is_memberlist_visible 1
      is_content_visible 1
      is_approval_required 0
    end

    trait :private do
      name "Factory:Private"
      description "Private"
      is_group_visible 1
      is_memberlist_visible 0
      is_content_visible 0
      is_approval_required 1
    end

    trait :secret do
      name "Factory:Secret"
      description "Secret"
      is_group_visible 0
      is_memberlist_visible 0
      is_content_visible 0
      is_approval_required 1
    end

  end

  factory :group_request do
    is_approved false    
    
    trait :approved do
      is_approved true
    end

  end

  factory :group_invite
  
end