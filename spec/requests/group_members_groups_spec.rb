require 'spec_helper'

describe "GroupMembersGroups" do

  before(:all) do
    @user = create(:user)
    @user1 = create(:user, :random)
    @group1 = create(:group, :random)
    @group2 = create(:group, :random)
    @group_member1 = create(:group_member, user: @user1, group: @group1)
    @group_member2 = create(:group_member, user: @user1, group: @group2)
  end

  it "GET /group_members/groups/:user_id; get 2 group_members records (2 groups)" do
    get_auth "/group_members/groups/#{@user1.id}"
    
    response.status.should eql(200)
    json["group_members"].count.should eq(2)
    json["group_members"].first["id"].should eq @group_member1.id
    json["group_members"].first["group"]["id"].should eq @group1.id
    json["group_members"].second["id"].should eq @group_member2.id
    json["group_members"].second["group"]["id"].should eq @group2.id
  end

  it "GET /group_members/groups/:user_id; receive 0 group_members records for a user" do
    get_auth "/group_members/groups/#{@user.id}"
    
    response.status.should eql(200)
    json["group_members"].count.should eq(0)
  end

  it "GET /group_members/groups/:user_id; receive 404 for a user that does not exist" do
    get_auth "/group_members/groups/0"
    
    response.status.should eql(404)  
  end

  xit "GET /group_members/groups/:user_id; attempts to get member list, turned off at app level" do
    create(:app_setting, app_setting_option_id: 13)

    get_auth "/group_members/groups/#{@user1.id}"
    
    response.status.should eql(200)
    json["group_members"].count.should eq(0)
  end  

end