require 'spec_helper'

describe 'EventUsersUsers' do
  
  it "GET /event_users/users/:event_id; get 2 event_users records ( 2 users )" do
    user1 = create(:user)
    user2 = create(:user, :random)
    group_type = create(:group_type, name: 'Open', description: "Open group")
    group = create(:group, name: "rspec test group", group_type: group_type)
    event = create(:event, name: "rspec test event", group: group)
    event_user1 = create(:event_user, user: user1, event: event)
    event_user2 = create(:event_user, user: user2, event: event)

    get_auth "/event_users/users/#{event.id}"
    response.status.should eql(200)
    json["event_users"].count.should eq(2)
    json["event_users"].first["id"].should eq event_user1.id
    json["event_users"].second["id"].should eq event_user2.id

  end

  it "GET /event_users/users/:event_id; get 0 event_users records for an event" do
    user = create(:user)
    group_type = create(:group_type, name: "Open", description: "Open group")
    group = create(:group, name: "rspec test group", group_type: group_type)
    event = create(:event, name: "rspec test event", group: group)
    
    get_auth "/event_users/users/#{event.id}"
    response.status.should eql(200)
    json["event_users"].count.should eq(0)
  end

  it "GET /event_users/users/:event_id; get 404 for an event that does not exist" do
    user = create(:user)

    get_auth "/event_users/users/0"
    response.status.should eql(404)
  end

end