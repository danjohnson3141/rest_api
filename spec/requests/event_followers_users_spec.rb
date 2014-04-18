require 'spec_helper'

describe 'EventFollowersUsers' do

  before(:all) do
    @user = create(:user)
    @user2 = create(:user, :random)
    @event = create(:event, :random)
    @event_follower1 = create(:event_follower, user: @user, event: @event)
    @event_follower2 = create(:event_follower, user: @user2, event: @event)
    @connect = create(:user_connection, is_approved: true, sender_user: @user, recipient_user: @user2)
  end

  it "GET /event_followers/users/:event_id; get 2 event_followers records ( 2 users )" do
    get_auth "/event_followers/users/#{@event.id}"

    response.status.should eql(200)
    json["event_followers"].count.should eq(2)
    json["event_followers"].first["id"].should eq @event_follower1.id
    json["event_followers"].second["id"].should eq @event_follower2.id
  end

  it "GET /event_followers/users/:event_id; get 0 event_followers records for an event" do
    event2 = create(:event, :random)

    get_auth "/event_followers/users/#{event2.id}"
    
    response.status.should eql(200)
    json["event_followers"].count.should eq(0)
  end

  it "GET /event_followers/users/:event_id; get 404 for an event that does not exist" do
    get_auth "/event_followers/users/0"

    response.status.should eql(404)
  end

end