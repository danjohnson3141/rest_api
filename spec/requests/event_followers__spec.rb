require 'spec_helper'

describe 'EventFollowers' do
  
  before(:all) do
    @user = create(:user)
    @event = create(:event, :random)
  end

  it "POST /event_followers; create new event follower" do
    post_auth '/event_followers', { event_follower: { user_id: @user.id, event_id: @event.id } }
    
    response.status.should eql(201)
    json["event_follower"]["user"]["id"].should eq @user.id
    json["event_follower"]["event"]["id"].should eq @event.id
  end  

  it "POST /event_followers; create new event follower not allowed" do
    create(:app_setting, app_setting_option_id: 128)
    post_auth '/event_followers', { event_follower: { user_id: @user.id, event: @event } }
    
    response.status.should eql(403)
  end  

  it "POST /event_followers; attempts to make another follow an event, still uses current user" do
    user1 = create(:user, :random)

    post_auth '/event_followers', { event_follower: { user_id: user1.id, event_id: @event.id } }
    response.status.should eql(201)
    json["event_follower"]["user"]["id"].should eq @user.id
    json["event_follower"]["event"]["id"].should eq @event.id
  end

  it "POST /event_followers; create new event follower, will fail because event is already being followed" do
    create(:event_follower, user: @user, event: @event)

    post_auth '/event_followers', { event_follower: { user_id: @user.id, event: @event } }
    response.status.should eql(422)
  end

  it "DELETE /event_followers/:id; delete an existing event follower" do
    event_follower = create(:event_follower, user: @user, event: @event, creator: @user)

    delete_auth "/event_followers/#{event_follower.id}"
    response.status.should eql(204)
  end  

  it "DELETE /event_followers/:id; attempts to delete a follower record for another user" do
    user1 = create(:user, :random)
    event_follower = create(:event_follower, user: user1, event: @event)

    delete_auth "/event_followers/#{event_follower.id}"
    response.status.should eql(403)
  end

  it "DELETE /event_followers/:id; delete a follower that does not exist" do
    delete_auth "/event_followers/0"
    response.status.should eql(404)
  end

end