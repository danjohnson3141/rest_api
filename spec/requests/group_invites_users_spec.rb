require 'spec_helper'

describe "GroupinviteUsers" do

  before(:all) do
    @user = create(:user)
    @user2 = create(:user, :random, first_name: "ZZZ", last_name: "AAA")
    @user3 = create(:user, :random, first_name: "AAA", last_name: "BBB")
    @user4 = create(:user, :random, first_name: "AAA", last_name: "AAA")
    @open_group_type = create(:group_type, :open)
    @private_group_type = create(:group_type, :private)
    @secret_group_type = create(:group_type, :secret)
  end

  it "GET /group_invites/users/:group_id; receives the users invited to join one group, sorted chronologically" do
    group = create(:group, :private, :random, owner: @user)
    invite1 = create(:group_invite, user: @user2, group: group, created_at: Time.now - 1.minute)
    invite2 = create(:group_invite, user: @user3, group: group, created_at: Time.now - 3.minute)
    invite3 = create(:group_invite, user: @user4, group: group, created_at: Time.now - 2.minute)

    get_auth "/group_invites/users/#{group.id}"

    response.status.should eql(200)
    json["group_invites"].first["user"]["id"].should eq(@user4.id)
    json["group_invites"].second["user"]["id"].should eq(@user2.id)
    json["group_invites"].third["user"]["id"].should eq(@user3.id)
    json["group_invites"].count.should eq(3)
  end

  it "GET /group_invites/users/:group_id; two group invites, one approved, should return only one" do
    group = create(:group, :secret, :random,  owner: @user)
    invite1 = create(:group_invite, user: @user2, group: group)
    invite2 = create(:group_invite, user: @user3, group: group)
    member = create(:group_member, group: group, user: @user2)

    get_auth "/group_invites/users/#{group.id}"

    response.status.should eql(200)
    json["group_invites"].count.should eq(1)
    json["group_invites"].first["user"]["id"].should eq(@user3.id)
  end

  it "GET /group_invites/users/:group_id; attempts to get invite list for group not owner of, group is public" do
    group = create(:group, :private, :random,  owner: @user3)
    invite = create(:group_invite, user: @user2, group: group)

    get_auth "/group_invites/users/#{group.id}"

    response.status.should eql(403)
  end

  it "GET /group_invites/users/:group_id; attempts to get invite list for group not owner of, group is private" do
    user3 = create(:user, :random)
    group = create(:group, :private, :random,  owner: @user3)
    invite = create(:group_invite, user: @user2, group: group)

    get_auth "/group_invites/users/#{group.id}"

    response.status.should eql(403)
  end

  it "GET /group_invites/users/:group_id; attempts to get invite list for group not owner of, group is secret, not member" do
    user3 = create(:user, :random)
    group = create(:group, :secret, :random, owner: @user3)
    invite = create(:group_invite, user: @user2, group: group)

    get_auth "/group_invites/users/#{group.id}"

    GroupMember.where("group_id = #{group.id} AND user_id = #{@user.id}").count.should eq(0)
    response.status.should eql(404)
  end

  it "GET /group_invites/users/:group_id; attempts to get invite list for group not owner of, group is secret, is member" do
    user3 = create(:user, :random)
    group = create(:group, :secret, :random, owner: @user3)
    invite = create(:group_invite, user: @user2, group: group)
    member = create(:group_member, group: group, user: @user)

    get_auth "/group_invites/users/#{group.id}"

    GroupMember.where("group_id = #{group.id} AND user_id = #{@user.id}").count.should eq(1)
    response.status.should eql(403)
  end

  it "GET /group_invites/users/:group_id; get 404 for a group invite that does not exist" do
    get_auth "/group_invites/users/0"

    response.status.should eql(404)
  end

end
