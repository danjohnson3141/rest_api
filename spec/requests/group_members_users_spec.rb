require 'spec_helper'

describe 'GroupMembersUsers' do

  before(:all) do
    @user = create(:user)
  end

  it "GET /group_members/users/:group_id; get 2 group_members records (2 users)" do
    user1 = create(:user, :random, last_name: "AAA")
    user2 = create(:user, :random, last_name: "BBB")
    group = create(:group)

    group_member1 = create(:group_member, user: user1, group: group)
    group_member2 = create(:group_member, user: user2, group: group)

    get_auth "/group_members/users/#{group.id}"
    response.status.should eql(200)
    json["group_members"].count.should eq(2)
    json["group_members"].first["id"].should eq group_member1.id
    json["group_members"].second["id"].should eq group_member2.id
  end


  it "GET /group_members/users/:group_id; get 0 group_members records for a group" do
    group = create(:group, owner: @user)
  
    get_auth "/group_members/users/#{group.id}"
    response.status.should eql(200)
    json["group_members"].count.should eq(0)
  end  

  it "GET /group_members/users/:group_id; Permission Denied when user role not allowed" do
    create(:app_setting, app_setting_option_id: 16, user_role: @user.user_role)
    group = create(:group, owner: @user)
    
    get_auth "/group_members/users/#{group.id}"
    response.status.should eql(403)
  end  

  it "GET /group_members/users/:group_id; attempts to get member list for private group, not member or owner" do
    user1 = create(:user, :random)
    group = create(:group, :private, owner: user1)
    create(:group_member, user: user1, group: group)    

    get_auth "/group_members/users/#{group.id}"
    response.status.should eql(403)
  end

  it "GET /group_members/users/:group_id; get 404 for an group that does not exist" do
    get_auth "/group_members/users/0"
    response.status.should eql(404)
  end
  
end