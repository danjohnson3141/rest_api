require 'spec_helper'

describe 'EventUsers' do

  before(:all) do
    @reg_stat = EventRegistrationStatus.find_by_key("registered")
    @user = create(:user)
    @event = create(:event, :random)
  end

  it "GET /event_users/:id; returns single event_user record with related event_notes and event_bookmarks made by current user" do
    event_user = create(:event_user, event: @event, user: create(:user, :random), event_registration_status: @reg_stat)
    event_note = create(:event_note, event_user: event_user, body: 'blah', creator: @user)
    event_bookmark = create(:event_bookmark, event_user: event_user, creator: @user)

    get_auth "/event_users/#{event_user.id}"

    response.status.should eql(200)
    json["event_user"]["id"].should eq event_user.id
    json["event_user"]["user"]["id"].should eq event_user.user.id
    json["event_user"]["event"]["id"].should eq @event.id
    json["event_user"]["event_note_id"].should eq event_note.id
    json["event_user"]["event_bookmark_id"].should eq event_bookmark.id
  end

  it "POST /event_users; create new event user, also checks on event_follower creation" do
    EventFollower.where(user: @user, event: @event).first.should_not be

    post_auth '/event_users', { event_user: { event_id: @event.id, event_registration_status_id: @reg_stat.id } }

    response.status.should eql(201)
    json["event_user"]["user"]["id"].should eq @user.id
    json["event_user"]["event"]["id"].should eq @event.id
    EventFollower.where(user: @user, event: @event).first.should be
  end

  it "POST /event_users; create new event user, also checks on event_follower creation" do
    EventFollower.where(user: @user, event: @event).first.should_not be

    post_auth '/event_users', { event_user: { event_id: @event.id, event_registration_status_id: @reg_stat.id } }

    response.status.should eql(201)
    json["event_user"]["user"]["id"].should eq @user.id
    json["event_user"]["event"]["id"].should eq @event.id
    EventFollower.where(user: @user, event: @event).first.should be
  end

  it "POST /event_users; create new event user, will fail because event user already exists" do
    create(:event_user, user: @user, event: @event)

    post_auth '/event_users', { event_user: { event: @event, event_registration_status_id: @reg_stat.id } }
    response.status.should eql(422)
  end

  it "POST /event_users; attempts to make another an event user, still uses current user" do
    user1 = create(:user, :random)

    post_auth '/event_users', { event_user: { user_id: user1.id, event_id: @event.id, event_registration_status_id: @reg_stat.id } }
    response.status.should eql(201)
    json["event_user"]["user"]["id"].should eq @user.id
    json["event_user"]["event"]["id"].should eq @event.id
  end

  it "DELETE /event_users/:id; delete an existing event user" do
    event_user = create(:event_user, user: @user, event: @event, creator: @user)

    delete_auth "/event_users/#{event_user.id}"
    response.status.should eql(204)
  end

  it "DELETE /event_users/:id; attempts to delete an event user record for another user" do
    user1 = create(:user, :random)
    event_user = create(:event_user, user: user1, event: @event, creator: user1)

    delete_auth "/event_users/#{event_user.id}"
    response.status.should eql(403)
  end

  it "DELETE /event_users/:id; delete a user that does not exist" do
    delete_auth "/event_users/0"
    response.status.should eql(404)
  end

end
