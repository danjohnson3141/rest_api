require 'spec_helper'

describe 'EventUsersAttendees' do
    
  before(:all) do
    @user = create(:user)
    @event = create(:event, :random)

    @user1 = create(:user, :random, last_name: 'Zebra', first_name: 'Bob', user_role: @user.user_role)
    @user2 = create(:user, :random, last_name: 'Aardvark', first_name: 'Allen', user_role: @user.user_role)
    @user3 = create(:user, :random, last_name: 'Aardvark', first_name: 'Zacharia', user_role: @user.user_role)

    @event_user1 = create(:event_user, :registered, user: @user1, event: @event)
    @event_user2 = create(:event_user, :registered, user: @user2, event: @event)
    @event_user3 = create(:event_user, :registered, user: @user3, event: @event)
  end

  it "GET /event_users/attendees/:event_id; 'show_attendees' and 'show_me_on_lists' not set to OFF.  Show all users ON (non defualt)" do
    create(:app_setting, app_setting_option_id: 20, event: @event)
    
    get_auth "/event_users/attendees/#{@event.id}"
    response.status.should eql(200)
    json["event_users"].count.should eq(3)
    json["event_users"].first["user"]["first_name"].should eq @user2.first_name
    json["event_users"].first["user"]["last_name"].should eq @user2.last_name
    json["event_users"].last["user"]["first_name"].should eq @user1.first_name
    json["event_users"].last["user"]["last_name"].should eq @user1.last_name
  end

  it "GET /event_users/attendees/:event_id; 'show_me_on_lists' set to OFF at App level." do
    create(:app_setting, app_setting_option_id: 21)
    
    get_auth "/event_users/attendees/#{@event.id}"
    response.status.should eql(200)
    json["event_users"].count.should eq(0)
  end

  it "GET /event_users/attendees/:event_id; 'show_me_on_lists' set to OFF at UserRole level.  Sort order A-Z." do
    create(:app_setting, app_setting_option_id: 17, user_role: @user.user_role)
    
    get_auth "/event_users/attendees/#{@event.id}"
    response.status.should eql(200)
    json["event_users"].count.should eq(0)
  end

  it "GET /event_users/attendees/:event_id; 'show_me_on_lists' set to OFF at UserRole level.  Sort order A-Z." do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)
    
    get_auth "/event_users/attendees/#{@event.id}"
    response.status.should eql(200)
    json["event_users"].count.should eq(0)
  end

  it "GET /event_users/attendees/:event_id; 'show_me_on_lists' set to OFF at User level.  Sort order A-Z." do
    event_user4 = create(:event_user, :registered, user: @user, event: @event)
    create(:app_setting, app_setting_option_id: 18, user: @user)
    
    get_auth "/event_users/attendees/#{@event.id}"
    response.status.should eql(200)
    json["event_users"].count.should eq(3)
    json.to_s.should_not include(@user.first_name)
  end

  it "GET /event_users/attendees/:event_id; 'show_attendees_only_after_event_starts' set to OFF (default)" do    
    get_auth "/event_users/attendees/#{@event.id}"
    response.status.should eql(200)
    json["event_users"].count.should eq(3)
    json["event_users"].first["user"]["first_name"].should eq @user2.first_name
    json["event_users"].first["user"]["last_name"].should eq @user2.last_name
    json["event_users"].second["user"]["first_name"].should eq @user3.first_name
    json["event_users"].second["user"]["first_name"].should eq @user3.first_name
    json["event_users"].third["user"]["last_name"].should eq @user1.last_name    
    json["event_users"].third["user"]["last_name"].should eq @user1.last_name
  end

  it "GET /event_users/attendees/:event_id; get 0 event_users records for an event" do
    event2 = create(:event, :random)

    get_auth "/event_users/attendees/#{event2.id}"
    response.status.should eql(200)
    json["event_users"].count.should eq(0)
  end

  it "GET /event_users/attendees/:event_id; 'show_attendees' set to OFF at App level" do
    create(:app_setting, app_setting_option_id: 13)
    
    get_auth "/event_users/attendees/#{@event.id}"
    response.status.should eql(403)
  end

  it "GET /event_users/attendees/:event_id; 'show_attendees' set to OFF at Event level" do
    create(:app_setting, app_setting_option_id: 14, event: @event)
    
    get_auth "/event_users/attendees/#{@event.id}"
    response.status.should eql(403)
  end
  
  it "GET /event_users/attendees/:event_id; 'show_attendees' set to OFF at UserRole level" do
    create(:app_setting, app_setting_option_id: 16, user_role: @user.user_role)
    
    get_auth "/event_users/attendees/#{@event.id}"
    response.status.should eql(403)
  end

  it "GET /event_users/attendees/:event_id; get 404 for an event that does not exist" do
    get_auth "/event_users/attendees/0"
    response.status.should eql(404)
  end

end