require 'spec_helper'

describe 'GroupRequests' do

  before(:all) do
    @user = create(:user, :random)
    @requestor = create(:user, :random)
    @group = create(:group, :open, owner: @user)
  end

  it "approving a group request creates group_member record, notifies requestor, notifies the group owner" do
    group_request = GroupRequest.create(user: @requestor, group: @group)
    group_request.approve
    GroupMember.where(user: group_request.user, group: group_request.group).first.present?.should eq true
    Notification.where(notification_user: group_request.user, group: group_request.group).first.body.should eq "Your request to join #{group_request.group.name} has been approved."
    Notification.where(notification_user: group_request.group.owner, group: group_request.group).first.body.should eq "#{group_request.user.full_name} has joined your group \"#{group_request.group.name}\"."
  end
  
  it "approving a group request creates group_member record, doesn't notify requestor or group owner because notifications are turned off (App level)" do
    create(:app_setting, app_setting_option_id: 57)
    group_request = GroupRequest.create(user: @requestor, group: @group)
    group_request.approve
    GroupMember.where(user: group_request.user, group: group_request.group).first.present?.should eq true
    Notification.where(notification_user: group_request.user, group: group_request.group).first.present?.should eq false
    Notification.where(notification_user: group_request.group.owner, group: group_request.group).first.present?.should eq false
  end

  it "approving a group request creates group_member record, doesn't notify requestor or group owner because notifications are turned off (UserRole level)" do
    create(:app_setting, app_setting_option_id: 58, user_role: @group.owner.user_role)
    group_request = GroupRequest.create(user: @requestor, group: @group)
    group_request.approve
    GroupMember.where(user: group_request.user, group: group_request.group).first.present?.should eq true
    Notification.where(notification_user: group_request.user, group: group_request.group).first.present?.should eq false
    Notification.where(notification_user: group_request.group.owner, group: group_request.group).first.present?.should eq false
  end

end
