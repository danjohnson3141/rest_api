require 'spec_helper'

describe "UserSettings" do

  before(:all) do
    @user = create(:user)
    
  end

  it "GET /users/settings; gets all app_setting_options" do
    get_auth "/users/settings"
    response.status.should eq(200)

    json["app_setting_options"].count.should eq 20
    json["app_setting_options"][0]["id"].should eq 56
    json["app_setting_options"][1]["id"].should eq 50
    json["app_setting_options"][2]["id"].should eq 51
    json["app_setting_options"][3]["id"].should eq 117
    json["app_setting_options"][4]["id"].should eq 119
    json["app_setting_options"][5]["id"].should eq 121
    json["app_setting_options"][6]["id"].should eq 122
    json["app_setting_options"][7]["id"].should eq 123
    json["app_setting_options"][8]["id"].should eq 124
    json["app_setting_options"][9]["id"].should eq 130
    json["app_setting_options"][10]["id"].should eq 18
    json["app_setting_options"][11]["id"].should eq 45
    json["app_setting_options"][12]["id"].should eq 46
    json["app_setting_options"][13]["id"].should eq 29
    json["app_setting_options"][14]["id"].should eq 32
    json["app_setting_options"][15]["id"].should eq 35
    json["app_setting_options"][16]["id"].should eq 179
    json["app_setting_options"][17]["id"].should eq 38
    json["app_setting_options"][18]["id"].should eq 39
    json["app_setting_options"][19]["id"].should eq 40    

    20.times do |x|
      json["app_setting_options"][x]["setting"].should eq false
      json["app_setting_options"][x]["app_setting_id"].should eq nil
    end
  end

  it "GET /users/settings; returns all app_setting_options - turns on an indvidual setting" do
    app_setting = create(:app_setting, app_setting_option_id: 56, user: @user)

    get_auth "/users/settings"
    response.status.should eq(200)
    json["app_setting_options"].count.should eq 20
    json["app_setting_options"][0]["id"].should eq 56
    json["app_setting_options"][0]["name"].should eq app_setting.app_setting_option.name
    json["app_setting_options"][0]["description"].should eq app_setting.app_setting_option.description
    json["app_setting_options"][0]["setting"].should eq true
    json["app_setting_options"][0]["app_setting_id"].should eq app_setting.id
  end

  it "GET /users/settings; attempts to return app_setting_options - option is disabled for user_role" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 56, user: @user)

    get_auth "/users/settings"
    response.status.should eq(403)
  end

  it "GET /users/settings; remove a setting as a user option based upon other upstream settings" do
    create(:app_setting, app_setting_option_id: 55, user_role: @user.user_role)

    get_auth "/users/settings"
    response.status.should eq(200)
    json["app_setting_options"].count.should eq 19
    json["app_setting_options"].map {|x| x["id"]}.should_not include 56
  end


end
