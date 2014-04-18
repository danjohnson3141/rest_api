require 'spec_helper'

describe "GroupInvites" do

  before(:all) do
    @user = create(:user)
  end


  it "POST /group_invites; creates a new group invite, invitee's user role is not permitted to join groups, fails" do
    invitee = create(:user, :random)
    group = create(:group, :private, owner: @user)
    create(:app_setting, app_setting_option_id: 7, user_role: invitee.user_role)
  
    post_auth "/group_invites", { group_invite: { user_id: invitee.id, group_id: group.id } }

    response.status.should eql(403)
  end

  it "POST /group_invites; creates a new group invite" do
    invitee = create(:user, :random)
    group = create(:group, :private, owner: @user)

    post_auth "/group_invites", { group_invite: { user_id: invitee.id, group_id: group.id } }

    response.status.should eql(201)
    json["group_invite"]["user"]["id"].should eq(invitee.id)
    json["group_invite"]["group"]["id"].should eq(group.id)
  end

  it "POST /group_invites; creates a new group invite" do
    invitee = create(:user, :random)
    group = create(:group, :private, owner: @user)

    post_auth "/group_invites", { group_invite: { user_id: invitee.id, group_id: group.id } }
    response.status.should eql(201)
    json["group_invite"]["user"]["id"].should eq(invitee.id)
    json["group_invite"]["group"]["id"].should eq(group.id)
  end

  it "POST /group_invites; tries to create an invite for a group that not owner of" do
    user1 = create(:user, :random)
    user2 = create(:user, :random)
    group = create(:group, :private, owner: user1)

    post_auth "/group_invites", { group_invite: { user_id: user1.id, group_id: group.id, created_by: user2.id } }
    response.status.should eql(403)
  end

  it "POST /group_invites; tries to create an invite for a group that not owner of, is secret, not member" do
    user1 = create(:user, :random)
    user2 = create(:user, :random)
    group = create(:group, :secret, owner: user1)

    post_auth "/group_invites", { group_invite: { user_id: user1.id, group: group, created_by: user2.id } }
    response.status.should eql(404)
  end

  it "POST /group_invites; tries to create an invite for a group that not owner of, is secret, is member" do
    user1 = create(:user, :random)
    user2 = create(:user, :random)
    group = create(:group, :secret, owner: user1)
    member = create(:group_member, group: group, user: @user)

    post_auth "/group_invites", { group_invite: { user_id: user1.id, group_id: group.id, created_by: user2.id } }
    response.status.should eql(403)
  end

  it "POST /group_invites; tries to creates a new group invite, fails due to already existing" do
    group = create(:group, owner: @user)
    create(:group_invite, user: @user, group: group)

    post_auth "/group_invites", { group_invite: { user_id: @user.id, group_id: group.id } }
    response.status.should eql(422)
  end

  it "POST /group_invites; attempts to invite someone who's already a member" do
    user1 = create(:user, :random)
    group = create(:group, owner: @user)
    group_member = create(:group_member, user: user1, group: group)

    post_auth "/group_invites", { group_invite: { user_id: user1.id, group_id: group.id } }
    response.status.should eql(422)
  end

  it "DELETE /group_invites/:id; attempts to delete an existing group invite" do
    user1 = create(:user, :random)
    group = create(:group, owner: @user)
    group_invite = create(:group_invite, user: user1, group: group, created_by: @user)

    delete_auth "/group_invites/#{group_invite.id}"
    response.status.should eql(403)
  end

  it "DELETE /group_invites/:id; recipient deletes a pending group invite" do
    user1 = create(:user, :random)
    group = create(:group, )
    group_invite = create(:group_invite, user: @user, group: group, created_by: user1)

    delete_auth "/group_invites/#{group_invite.id}"
    response.status.should eql(204)
  end

  it "DELETE /group_invites/:id; attempts to delete an invite not part of" do
    user1 = create(:user, :random)
    user2 = create(:user, :random)
    group = create(:group, owner: user1)
    group_invite = create(:group_invite, user: user2, group: group)

    delete_auth "/group_invites/#{group_invite.id}"
    response.status.should eql(403)
  end

  it "DELETE /group_invites/:id; delete a group invite that does not exist" do
    delete_auth "/group_invites/0"
    response.status.should eql(404)
  end

  it "POST /group_invites; creates a new group invite when a group request exists" do
    invitee = create(:user, :random)
    group = create(:group, :private, owner: @user)
    group_request = create(:group_request, user: invitee, group: group, created_at: Time.now - 1.minute)
    post_auth "/group_invites", { group_invite: { user_id: invitee.id, group_id: group.id } }

    response.status.should eql(201)
    json["group_invite"]["user"]["id"].should eq(invitee.id)
    json["group_invite"]["group"]["id"].should eq(group.id)
    Notification.where(group: group, user: invitee).count.should be 1
    GroupRequest.find(group_request.id).is_approved.present?.should be true
    GroupMember.where(group: group, user: invitee).first.present?.should eq true
  end
end
