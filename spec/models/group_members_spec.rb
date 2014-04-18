require 'spec_helper'

describe 'GroupMembers' do

  before(:all) do
    user_role_notification_on = create(:user_role, name: 'notification on')
    user_role_notification_off = create(:user_role, name: 'notification off')
    @user = create(:user, :random)
    @group = create(:group, :open, owner: @user)
    @user_connection1 = create(:user_connection, :approved, sender_user: @user, recipient_user: create(:user, :random, user_role: user_role_notification_on))
    @user_connection2 = create(:user_connection, :approved, sender_user: create(:user, :random, user_role: user_role_notification_off), recipient_user: @user)
  end

  it "creating a group member notifies the group owner" do
    group_member = GroupMember.create(user: create(:user, :random), group: @group)
    Notification.where(notification_user: @group.owner, body: "#{group_member.user.full_name} has joined your group \"#{group_member.group.name}\".", user: group_member.user).present?.should eq true
  end

  it "creating a group member notifies the group owner, don't notify group owner when they automatically join the group they just created" do
    group_member = GroupMember.create(user: @user, group: @group)
    Notification.where(notification_user: @user, body: "#{group_member.group.owner.full_name} has joined your group \"#{group_member.group.name}\".").present?.should eq false
  end

  it "creating a group member doesn't notifies the group owner when their notifications app setting is off (App level)" do
    create(:app_setting, app_setting_option_id: 57)
    group_member = GroupMember.create(user: @user, group: @group)
    Notification.where(notification_user: @group.owner, group: @group).first.present?.should eq false
  end

  it "creating a group member doesn't notifies the group owner when their notifications app setting is off (UserRole level)" do
    create(:app_setting, app_setting_option_id: 58, user_role: @group.owner.user_role)
    group_member = GroupMember.create(user: @user, group: @group)
    Notification.where(notification_user: @group.owner, group: @group).first.present?.should eq false
  end

end
