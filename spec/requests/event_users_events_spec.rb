    require 'spec_helper'

describe 'EventUsersEvents' do  

  it "GET /event_users/events/:user_id; get 2 event_users records (2 events)" do
    user = create(:user)
    group_type = create(:group_type, name: 'Open', description: "Open group")
    group = create(:group, :random)
    event1 = create(:event, :random, :future, group: group)
    event2 = create(:event, :random, :future, group: group)
    spons1 = create(:sponsor, event: event1)
    spons2 = create(:sponsor, event: event2)
    event_follower1 = create(:event_follower, user: user, event: event1)
    event_follower2 = create(:event_follower, user: user, event: event2)
    event_user1 = create(:event_user, :registered, user: user, event: event1, sponsor: spons1)
    event_user2 = create(:event_user, :attended, user: user, event: event2, sponsor: spons2)

    get_auth "/event_users/events/#{user.id}"
    response.status.should eql(200)
    json["event_users"].count.should eq(2)
    json["event_users"].first["id"].should eq event_user1.id
    json["event_users"].first["event"]["id"].should eq event1.id
    json["event_users"].second["id"].should eq event_user2.id
    json["event_users"].second["event"]["id"].should eq event2.id
  end

  it "GET /event_users/events/:user_id; get 0 event_users records for a user" do
    user = create(:user)

    get_auth "/event_users/events/#{user.id}"
    response.status.should eql(200)
    json["event_users"].count.should eq(0)
  end

  it "GET /event_users/events/:user_id; get a 404 status when using invalid user" do
    user = create(:user)
    non_existant_user_id = User.maximum(:id) + 1

    get_auth "/event_users/events/#{non_existant_user_id}"
    response.status.should eql(404)  
  end

end