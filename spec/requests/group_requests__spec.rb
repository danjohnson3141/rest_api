require 'spec_helper'

describe "GroupRequests" do

  before(:all) do
    @user = create(:user)
  end

  it "POST /group_requests; creates a new group request for a user" do
    group = create(:group)

    post_auth "/group_requests", { group_request: { user_id: @user.id, group_id: group.id } }
    response.status.should eq 201
    json["group_request"]["user"]["id"].should eq(@user.id)
    json["group_request"]["group"]["id"].should eq(group.id)
  end

  it "POST /group_requests; tries to create a new group request, fails due to already existing" do
    group = create(:group)
    create(:group_request, user: @user, group: group)

    post_auth "/group_requests", { group_request: { user_id: @user.id, group_id: group.id } }
    response.status.should eq 422
  end

  it "PATCH /group_requests/:id; approve a pending request" do
    requester = create(:user, :random)
    group = create(:group, :private, owner: @user)
    group_request = create(:group_request, user: requester, group: group)

    patch_auth "/group_requests/#{group_request.id}"
    
    response.status.should eq 204
    GroupRequest.find(group_request.id).is_approved.should eq true
    GroupMember.where(group: group_request.group, user: group_request.user).first.should be
    group_request_notification = Notification.where(notification_user: group_request.user, group: group_request.group).first
    owner_notification = Notification.where(notification_user: group_request.group.owner, group: group_request.group).first
    group_request_notification.notification_user.should eq group_request.user
    group_request_notification.group.should eq group_request.group
    group_request_notification.body.should eq "Your request to join #{group_request.group.name} has been approved."
    owner_notification.notification_user.should eq group_request.group.owner
    owner_notification.group.should eq group_request.group
    owner_notification.body.should eq "#{group_request.user.full_name} has joined your group \"#{group_request.group.name}\"."
  end

  it "PUT /group_requests/:id; approve a pending request. Reqestor is notified, onwer is not because their notification setting is off" do
    requester = create(:user, :sponsor, :random)
    group = create(:group, :private, owner: @user)
    group_request = create(:group_request, user: requester, group: group)
    create(:app_setting, app_setting_option_id: 58, user_role: group.owner.user_role)

    put_auth "/group_requests/#{group_request.id}"

    response.status.should eq 204
    GroupRequest.find(group_request.id).is_approved.should eq true
    GroupMember.where(group: group_request.group, user: group_request.user).first.should be
    group_request_notification = Notification.where(notification_user: group_request.user, group: group_request.group).first
    owner_notification = Notification.where(notification_user: group_request.group.owner, group: group_request.group).first
    group_request_notification.notification_user.should eq group_request.user
    group_request_notification.group.should eq group_request.group
    group_request_notification.body.should eq "Your request to join #{group_request.group.name} has been approved."
    owner_notification.present?.should eq false
  end

  it "PUT /group_requests/:id; approve a pending request. Reqestor is not notified because their notification setting is off" do
    requester = create(:user, :sponsor, :random)
    group = create(:group, :private, owner: @user)
    group_request = create(:group_request, user: requester, group: group)
    create(:app_setting, app_setting_option_id: 58, user_role: group_request.user.user_role)

    put_auth "/group_requests/#{group_request.id}"

    response.status.should eq 204
    GroupRequest.find(group_request.id).is_approved.should eq true
    GroupMember.where(group: group_request.group, user: group_request.user).first.should be
    group_request_notification = Notification.where(notification_user: group_request.user, group: group_request.group).first
    owner_notification = Notification.where(notification_user: group_request.group.owner, group: group_request.group).first
    group_request_notification.present?.should eq false
    owner_notification.notification_user.should eq group_request.group.owner
    owner_notification.group.should eq group_request.group
    owner_notification.body.should eq "#{group_request.user.full_name} has joined your group \"#{group_request.group.name}\"."
  end

  it "DELETE /group_requests/:id; requestor deletes a group request, success" do
    group = create(:group)
    group_request = create(:group_request, user: @user, group: group)

    delete_auth "/group_requests/#{group_request.id}"
    response.status.should eq 204
  end

  it "DELETE /group_requests/:id; group owner deletes a group request, success" do
    group = create(:group, owner: @user)
    group_request = create(:group_request, user: create(:user, :random), group: group)

    delete_auth "/group_requests/#{group_request.id}"
    response.status.should eq 204
  end

  it "DELETE /group_requests/:id; someone other than group owner or requestor attempts to delete a group request, failure" do
    group = create(:group, owner: create(:user, :random))
    group_request = create(:group_request, user: create(:user, :random), group: group)

    delete_auth "/group_requests/#{group_request.id}"
    response.status.should eq 403
  end

  it "DELETE /group_requests/:id; delete a group invite that does not exist" do
    delete_auth "/group_requests/0"

    response.status.should eq 404
  end

  it "POST /group_requests; creates a new group request for a user when an invite exists" do
    group = create(:group)
    invite1 = create(:group_invite, user: @user, group: group, created_at: Time.now - 1.minute)

    post_auth "/group_requests", { group_request: { user_id: @user.id, group_id: group.id } }
    response.status.should eq 201
    json["group_request"]["user"]["id"].should eq(@user.id)
    json["group_request"]["group"]["id"].should eq(group.id)
    GroupRequest.where(group: group, user: @user).first.is_approved.should eq true
    GroupMember.where(group: group, user: @user).first.should be
    Notification.where(group: group, notification_user: @user).count.should be 2
  end

end