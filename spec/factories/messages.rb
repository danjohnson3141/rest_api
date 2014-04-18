FactoryGirl.define do

  factory :message do
  	created_at Time.now 
  	body "DEFAULT TEXT IS SO BORING"
  	
  	trait :sequence do
      sequence(:body) { |n| "message #{n}" }
  	end

  	trait :random do
  	  body {Faker::Company.catch_phrase}
  	end
  
  end

end


