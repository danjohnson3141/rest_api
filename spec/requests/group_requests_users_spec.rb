require 'spec_helper'

describe "GroupRequestUsers" do

  before(:all) do
    @user = create(:user)
    @user1 = create(:user, :random)
    @user2 = create(:user, :random)
    @user3 = create(:user, :random)
    @open_group_type = create(:group_type, :open)
    @private_group_type = create(:group_type, :private)
    @secret_group_type = create(:group_type, :secret)
  end

  it "GET /group_requests/users/:group_id; receives the users requesting to join one group, sorted chronologically" do
    group = create(:group, :private, :random, owner: @user)
    request1 = create(:group_request, user: @user1, group: group, created_at: Time.now - 1.minute)
    request2 = create(:group_request, user: @user2, group: group, created_at: Time.now - 3.minute)
    request3 = create(:group_request, user: @user3, group: group, created_at: Time.now - 2.minute)
    
    get_auth "/group_requests/users/#{group.id}"
    response.status.should eql(200)
    json["group_requests"].first["user"]["id"].should eq(@user2.id)
    json["group_requests"].second["user"]["id"].should eq(@user3.id)
    json["group_requests"].third["user"]["id"].should eq(@user1.id)
    json["group_requests"].count.should eq(3)
  end

  it "GET /group_requests/users/:group_id; attempts to get request list for group not owner of, group is public" do
    group = create(:group, :private, :random,  owner: @user3)
    request = create(:group_request, user: @user1, group: group)

    get_auth "/group_requests/users/#{group.id}"
    response.status.should eql(403)
  end    

  it "GET /group_requests/users/:group_id; attempts to get request list for group not owner of, group is private" do
    user2 = create(:user, :random)
    group = create(:group, :private, :random,  owner: @user3)
    request = create(:group_request, user: @user1, group: group)

    get_auth "/group_requests/users/#{group.id}"
    response.status.should eql(403)
  end  

  it "GET /group_requests/users/:group_id; attempts to get request list for group not owner of, group is secret, requester not member" do
    group = create(:group, :secret, :random, owner: @user3)
    request = create(:group_request, user: @user1, group: group)

    get_auth "/group_requests/users/#{group.id}"
    
    GroupMember.where("group_id = #{group.id} AND user_id = #{@user.id}").count.should eq(0)
    response.status.should eql(404)
  end   

  it "GET /group_requests/users/:group_id; attempts to get request list for group not owner of, group is secret, requester is member" do
    group = create(:group, :secret, :random, owner: @user3)
    request = create(:group_request, user: @user1, group: group)
    member = create(:group_member, group: group, user: @user)

    get_auth "/group_requests/users/#{group.id}"
    GroupMember.where("group_id = #{group.id} AND user_id = #{@user.id}").count.should eq(1)
    response.status.should eql(403)
  end   

  it "GET /group_requests/users/:group_id; two group requests, one approved, should return only one" do
    group = create(:group, :secret, :random,  owner: @user)
    request1 = create(:group_request, user: @user1, group: group, is_approved: true)
    request2 = create(:group_request, user: @user2, group: group)

    get_auth "/group_requests/users/#{group.id}"
    response.status.should eql(200)
    json["group_requests"].count.should eq(1)
    json["group_requests"].first["user"]["id"].should eq(@user2.id)
  end  

  it "GET /group_requests/users/:group_id; get 404 for a group invite that does not exist" do
    get_auth "/group_requests/users/0"
    response.status.should eql(404)
  end

end