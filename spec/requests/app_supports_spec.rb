require 'spec_helper'

describe 'AppSupports' do

  before(:all) do
    @user = create(:user)
  end

  it "POST /app_supports; logged in user creates new app_support record" do
    post_auth '/app_supports', { app_support: { body: "I need help!!!" } }
    response.status.should eql(201)
    json["app_support"]["id"].should be
    json["app_support"]["created_by_user"].should eq @user.first_name + ' ' + @user.last_name
    json["app_support"]["body"].should eq "I need help!!!"
  end

  it "POST /app_supports; not logged in user creates new app_support record" do
    post '/app_supports', { app_support: { body: "I need help!!!", email: 'dan@example.com' } }
    response.status.should eql(201)
    json["app_support"]["id"].should be
    json["app_support"]["created_by"].should_not be
    json["app_support"]["body"].should eq "I need help!!!"
    json["app_support"]["email"].should eq "dan@example.com"
  end 

  it "POST /app_supports; invalid email address" do
    post '/app_supports', { app_support: { body: "I need help!!!", email: 'dan@invalid' } }
    response.status.should eql(422)
    json["email"].should eq ["invalid email address: dan@invalid"]
  end 

  it "POST /app_supports; empty email address" do
    post '/app_supports', { app_support: { body: "I need help!!!" } }
    response.status.should eql(201)
    json["app_support"]["id"].should be
    json["app_support"]["created_by"].should_not be
    json["app_support"]["body"].should eq "I need help!!!"
    json["app_support"]["email"].should_not be
  end  

  it "POST /app_supports; attempts to create a new app_support record with a body that's too long" do
    too_long_title = Faker::Lorem.characters(2001)
    
    post_auth '/app_supports', { app_support: { body: too_long_title } }
    response.status.should eql(422)
    json["body"].should eq(["is too long (maximum is 2000 characters)"])
  end

  it "POST /app_supports; attempts to create a new app_support record with a body" do
    post_auth '/app_supports', { app_support: { body: "" } }
    response.status.should eql(422)
    json["body"].should eq(["can't be blank"])
  end

end