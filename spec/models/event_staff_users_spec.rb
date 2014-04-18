require 'spec_helper'

describe 'EventStaffUser' do

  before(:all) do
    @reg_stat = EventRegistrationStatus.find_by_key("registered")    
    @user = create(:user, :random)
    @event = create(:event, :random)
  end

  it "creating an event staff user also creates and event user record" do
    EventStaffUser.create(user: @user, event: @event)
    EventUser.where(user: @user, event: @event).first.should be
    EventFollower.where(user: @user, event: @event).first.should be
  end

  it "creating an event user also creates and event user record, does nothing if event user record already exists" do
    EventUser.create(user: @user, event: @event, event_registration_status: @reg_stat)
    EventStaffUser.create(user: @user, event: @event)
    EventUser.where(user: @user, event: @event).first.should be
  end
end
