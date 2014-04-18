require 'spec_helper'

describe 'Groups' do

  before(:all) do
    @user = create(:user)
    user_role_notification_on = create(:user_role, name: 'notification on')
    user_role_notification_off = create(:user_role, name: 'notification off')
    
    @user_connection1 = create(:user_connection, :approved, sender_user: @user, recipient_user: create(:user, :random, user_role: user_role_notification_on))
    @user_connection2 = create(:user_connection, :approved, sender_user: create(:user, :random, user_role: user_role_notification_off), recipient_user: @user)
  end

  it "open group" do
    group = create(:group, :open)
    group.open?.should eq true
    group.private?.should eq false
    group.secret?.should eq false
  end

  it "private group" do
    group = create(:group, :private)
    group.open?.should eq false
    group.private?.should eq true
    group.secret?.should eq false
  end

  it "secret group" do
    group = create(:group, :secret)
    group.open?.should eq false
    group.private?.should eq false
    group.secret?.should eq true
  end

  it "creating an open group notifies the group owner's connections, when settings permit" do
    group = create(:group, :open, owner: @user)
    Notification.where(notification_user: @user_connection1.recipient_user, body: "#{group.owner.full_name} has created group \"#{group.name}\".", user: group.owner).first.present?.should eq true
    Notification.where(notification_user: @user_connection2.sender_user, body: "#{group.owner.full_name} has created group \"#{group.name}\".", user: group.owner).first.present?.should eq true
  end

  it "creating an open group does not notify the group owner's connections if notification setting is off (57-App level)" do
    create(:app_setting, app_setting_option_id: 57)
    group = create(:group, :open, owner: @user)
    Notification.where(notification_user: @user_connection1.recipient_user, body: "#{group.owner.full_name} has created group \"#{group.name}\".", user: group.owner).first.present?.should eq false
    Notification.where(notification_user: @user_connection2.sender_user, body: "#{group.owner.full_name} has created group \"#{group.name}\".", user: group.owner).first.present?.should eq false
  end

  it "creating an open group does not notify the group owner's connections if notification setting is off (58 UserRole level)" do
    create(:app_setting, app_setting_option_id: 58, user_role: @user_connection1.recipient_user.user_role)
    group = create(:group, :open, owner: @user)
    Notification.where(notification_user: @user_connection1.recipient_user, body: "#{group.owner.full_name} has created group \"#{group.name}\".", user: group.owner).first.present?.should eq false
    Notification.where(notification_user: @user_connection2.sender_user, body: "#{group.owner.full_name} has created group \"#{group.name}\".", user: group.owner).first.present?.should eq true
  end
end