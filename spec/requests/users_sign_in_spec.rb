require 'spec_helper'

describe 'UserSignIn' do

  before(:all) do
    @user = create(:user)
  end

  it "POST /users/sign_in; good login credentials" do
    post '/users/sign_in', { user: { email: @user.email, password: @user.password} }
    
    response.status.should eql(200)
    json["success"].should eq(true)
    json['auth_token'].should be
  end  

  it "POST /users/sign_in; bad password" do
    post '/users/sign_in', { user: { email: @user.email, password: "badPassword"} }

    response.status.should eql(401)
    json["errors"].should eq ["access_denied"]
  end

  it "POST /users/sign_in; account disabled" do
    create(:app_setting, app_setting_option_id: 182, user_role: @user.user_role)
    
    post '/users/sign_in', { user: { email: @user.email, password: @user.password} }
    
    response.status.should eql(401)
    json["errors"].should eq ["account_disabled"]
  end

 end