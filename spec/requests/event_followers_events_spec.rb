require 'spec_helper'

describe 'EventFollowersEvents' do  
  
  before(:all) do
    @user = create(:user)
  end

  it "GET /event_followers/events/:user_id; get 2 event_followers records (2 events)" do
    group = create(:group)
    event1 = create(:event, name: "rspec test event 1", group: group)
    event2 = create(:event, name: "rspec test event 2", group: group)
    event_follower1 = create(:event_follower, user: @user, event: event1)
    event_follower2 = create(:event_follower, user: @user, event: event2)
    
    get_auth "/event_followers/events/#{@user.id}"
    response.status.should eql(200)
    json["event_followers"].count.should eq(2)
    json["event_followers"].first["id"].should eq event_follower1.id
    json["event_followers"].first["event"]["id"].should eq event1.id
    json["event_followers"].second["id"].should eq event_follower2.id
    json["event_followers"].second["event"]["id"].should eq event2.id
  end

  it "GET /event_followers/events/:user_id; get 0 event_followers records for a user" do
    get_auth "/event_followers/events/#{@user.id}"
    response.status.should eql(200)
    json["event_followers"].count.should eq(0)
  end

  it "GET /event_followers/events/:user_id; requests a user ID that is invalid" do
    get_auth "/event_followers/events/0"
    response.status.should eql(404)  
  end

end