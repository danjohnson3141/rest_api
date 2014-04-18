require 'spec_helper'

describe 'EventUserSchedules' do

  before(:all) do
    @user = create(:user)
    @event = create(:event, :random)
    @event_session = create(:event_session, :random, event: @event)
    
  end

  it "POST /event_user_schedules; create new event user schedule" do
    event_user = create(:event_user, user: @user, event: @event)

    post_auth '/event_user_schedules', { event_user_schedule: { event_session_id: @event_session.id } }

    response.status.should eql(201)
    json["event_user_schedule"]["event_session"]["id"].should eq @event_session.id
    json["event_user_schedule"]["event_user"]["id"].should eq event_user.id
    json["event_user_schedule"]["event_user"]["user"]["id"].should eq @user.id
  end

  it "DELETE /event_user_schedules/:id; delete an existing event user schedule" do
    event_user = create(:event_user, event: @event, user: @user)
    event_user_schedule = create(:event_user_schedule, event_user: event_user, event_session: @event_session)

    delete_auth "/event_user_schedules/#{event_user_schedule.id}"
    
    response.status.should eql(204)
  end

  it "POST /event_user_schedules; create new event user schedule, will fail because user is not event user" do
    post_auth '/event_user_schedules', { event_user_schedule: { event_session_id: @event_session.id } }
    
    response.status.should eql(403)
  end

  it "DELETE /event_user_schedules/:id; attempts to delete an event user schedule record for another user" do
    user1 = create(:user, :random)
    event_user = create(:event_user, user: user1, event: @event)
    event_user_schedule = create(:event_user_schedule, event_user: event_user, event_session: @event_session)

    delete_auth "/event_user_schedules/#{event_user_schedule.id}"
    
    response.status.should eql(403)
  end

  it "DELETE /event_user_schedules/:id; delete a user schedule that does not exist" do
    delete_auth "/event_user_schedules/0"
    
    response.status.should eql(404)
  end

  it "POST /event_user_schedules; create new event user schedule, will fail because event user schedule already exists" do
    event_user = create(:event_user, event: @event, user: @user)
    event_user_schedule = create(:event_user_schedule, event_user: event_user, event_session: @event_session)

    post_auth '/event_user_schedules', { event_user_schedule: { event_session_id: @event_session.id } }
    
    response.status.should eql(422)
  end

end