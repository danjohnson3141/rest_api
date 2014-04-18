require 'spec_helper'

describe 'GroupInvites' do

  before(:all) do
    @user = create(:user, :random)
    @invitee = create(:user, :random)
    @group = create(:group, :open, owner: @user)
  end

  it "inviting a user to your group notifies invitee" do
    group_invite = GroupInvite.create(user: @invitee, group: @group)
    Notification.where(notification_user: group_invite.user, group: group_invite.group, body: "You've been invited to join #{@group.name}.", user: @group.owner, group_invite: group_invite).present?.should eq true
  end
  
  it "inviting a user to your group doesn't notify invitee because notifications are turned off (App level)" do
    create(:app_setting, app_setting_option_id: 57)
    group_invite = GroupInvite.create(user: @invitee, group: @group)
    Notification.where(notification_user: group_invite.user, group: group_invite.group, user: @group.owner, group_invite: group_invite).present?.should eq false
  end

  it "inviting a user to your group doesn't notify invitee because notifications are turned off (UserRole level)" do
    create(:app_setting, app_setting_option_id: 58, user_role: @invitee.user_role)
    group_invite = GroupInvite.create(user: @invitee, group: @group)
    Notification.where(notification_user: group_invite.user, group: group_invite.group, user: @group.owner, group_invite: group_invite).present?.should eq false
  end

end
