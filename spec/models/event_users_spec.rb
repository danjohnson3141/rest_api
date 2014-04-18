require 'spec_helper'

describe 'EventUser' do

  before(:all) do
    user_role_notification_on = create(:user_role, name: 'notification on')
    user_role_notification_off = create(:user_role, name: 'notification off')
    @invited = EventRegistrationStatus.find_by_key("invited")
    @registered = EventRegistrationStatus.find_by_key("registered")
    @attended = EventRegistrationStatus.find_by_key("attended")
    @user = create(:user)
    @event = create(:event, :random)
    @user_connection1 = create(:user_connection, :approved, sender_user: @user, recipient_user: create(:user, :random, user_role: user_role_notification_on))
    @user_connection2 = create(:user_connection, :approved, sender_user: create(:user, :random, user_role: user_role_notification_off), recipient_user: @user)
  end

  it "creating an invited event user also creates and event follower record, no notification" do
    EventUser.create(user: @user, event: @event, event_registration_status: @invited)
    EventFollower.where(user: @user, event: @event).first.should be
    Notification.where(notification_user: @user_connection1.recipient_user, body: "#{@user.full_name} has registered for #{@event.name}.").first.present?.should eq false
    Notification.where(notification_user: @user_connection2.sender_user, body: "#{@user.full_name} has registered for #{@event.name}.").first.present?.should eq false
  end

  it "creating an attended event user also creates and event follower record, no notification" do
    EventUser.create(user: @user, event: @event, event_registration_status: @attended)
    EventFollower.where(user: @user, event: @event).first.should be
    Notification.where(notification_user: @user_connection1.recipient_user, body: "#{@user.full_name} has registered for #{@event.name}.").first.present?.should eq false
    Notification.where(notification_user: @user_connection2.sender_user, body: "#{@user.full_name} has registered for #{@event.name}.").first.present?.should eq false
  end

  it "creating an event user also creates and event follower record, does nothing if event follower record already exists" do
    EventFollower.create(user: @user, event: @event)
    EventUser.create(user: @user, event: @event, event_registration_status: @invited)
    EventFollower.where(user: @user, event: @event).first.should be
  end

  it "creating a registered event user notifies user's connections when settings permit" do
    EventUser.create(user: @user, event: @event, event_registration_status: @registered)
    Notification.where(notification_user: @user_connection1.recipient_user, body: "#{@user.full_name} has registered for #{@event.name}.", user: @user).first.present?.should eq true
    Notification.where(notification_user: @user_connection2.sender_user, body: "#{@user.full_name} has registered for #{@event.name}.", user: @user).first.present?.should eq true
  end

  it "creating a registered event user does not notify user's connections if connections notification setting is off (57-App level)" do
    create(:app_setting, app_setting_option_id: 57)
    EventUser.create(user: @user, event: @event, event_registration_status: @registered)
    Notification.where(notification_user: @user_connection1.recipient_user, body: "#{@user.full_name} has registered for #{@event.name}.", user: @user).first.present?.should eq false
    Notification.where(notification_user: @user_connection2.sender_user, body: "#{@user.full_name} has registered for #{@event.name}.", user: @user).first.present?.should eq false
  end

  it "creating a registered event user does not notify user's connections if connections notification setting is off (58-UserRole level)" do
    create(:app_setting, app_setting_option_id: 58, user_role: @user_connection1.recipient_user.user_role)
    EventUser.create(user: @user, event: @event, event_registration_status: @registered)
    Notification.where(notification_user: @user_connection1.recipient_user, body: "#{@user.full_name} has registered for #{@event.name}.", user: @user).first.present?.should eq false
    Notification.where(notification_user: @user_connection2.sender_user, body: "#{@user.full_name} has registered for #{@event.name}.", user: @user).first.present?.should eq true
  end
end
