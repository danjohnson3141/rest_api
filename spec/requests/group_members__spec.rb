require 'spec_helper'

describe 'GroupMembers' do

  before(:all) do
    @user = create(:user)
    @user1 =  create(:user, :random, first_name: "AAA", last_name: "AAA")
    @user2 =  create(:user, :random, first_name: "BBB", last_name: "AAA")
    @user3 =  create(:user, :random, first_name: "CCC", last_name: "CCC")
    
    @group_open = create(:group, :random, :open)
    @group_private = create(:group, :random, :private)
    @group_secret = create(:group, :random, :secret)
  end

  it "POST /group_members; create new group member (join an open group)" do
    post_auth '/group_members', { group_member: { group_id: @group_open.id } }
    
    response.status.should eql(201)
    json["group_member"]["id"].should be
    json["group_member"]["user"]["id"].should eq @user.id
    json["group_member"]["group"]["id"].should eq @group_open.id
  end  

  it "POST /group_members; create new group member, fails because already a member" do
    create(:group_member, user: @user, group: @group_open)

    post_auth '/group_members', { group_member: { group_id: @group_open.id } }
    response.status.should eql(422)
  end

  it "POST /group_members; attempts to join a secret group w/o request" do
    post_auth "/group_members", { group_member: { group_id: @group_secret.id } }
    response.status.should eql(404)
  end

  it "POST /group_members; attempts to join a private group w/o request" do
    post_auth "/group_members", { group_member: { group_id: @group_private.id } }
    
    response.status.should eql(403)
  end

  it "POST /group_members; attempts to join a group that doesn't exist" do
    post_auth "/group_members", { group_member: { group_id: 0 } }
    
    response.status.should eql(404)
  end

  it "POST /group_members; joins a group that an approved request exists for" do
    group_request = create(:group_request, :approved, group: @group_open, user: @user)

    post_auth "/group_members", { group_member: { group_id: @group_open.id } }
    response.status.should eql(201)
    json["group_member"]["id"].should be
    json["group_member"]["user"]["id"].should eq @user.id
    json["group_member"]["group"]["id"].should eq @group_open.id
  end

  it "POST /group_members; attempts to join a private group that an unapproved request exists for" do
    group_request = create(:group_request, group: @group_private, user: @user)

    post_auth "/group_members", { group_member: { group_id: @group_private.id } }
    response.status.should eql(403)
  end

  it "POST /group_members; joins a group that an inivte exists for" do
    group_invite = create(:group_invite, group: @group_open, user: @user)

    post_auth "/group_members", { group_member: { group_id: @group_open.id } }
    response.status.should eql(201)

    json["group_member"]["id"].should be
    json["group_member"]["user"]["id"].should eq @user.id
    json["group_member"]["group"]["id"].should eq @group_open.id
  end

  it "DELETE /group_members/:id; removes an existing group member (leave group)" do
    group_member = create(:group_member, user: @user, group: @group_open)

    delete_auth "/group_members/#{group_member.id}"
    response.status.should eql(204)
  end  

  it "DELETE /group_members/:id; removes an existing group member (leave group), fails because owner is trying to leave their group" do
    group = create(:group, owner: @user)
    group_member = create(:group_member, user: @user, group: group)

    delete_auth "/group_members/#{group_member.id}"
    response.status.should eql(403)
  end

  it "DELETE /group_members/:id; attempts to remove an incorrect group member" do
    delete_auth "/group_members/0"
    
    response.status.should eql(404)
  end

  it "DELETE /group_members/:id; attempts to remove someone else's group member" do
    group_member = create(:group_member, user: @user1, group: @group_open)

    delete_auth "/group_members/#{group_member.id}"
    response.status.should eql(403)
  end

  it "POST /group_members; attempts to join group, joining groups turned off at app level" do
    create(:app_setting, app_setting_option_id: 2)

    post_auth '/group_members', { group_member: { group_id: @group_open.id } }
    
    response.status.should eql(403)
  end   

  it "DELETE /group_members/:id; attempts to remove group_member, turned off at app level" do
    create(:app_setting, app_setting_option_id: 2)
    group_member = create(:group_member, user: @user, group: @group_open)

    delete_auth "/group_members/#{group_member.id}"
    response.status.should eql(403)
  end  

  it "POST /group_members; attempts to join group, joining groups turned off at app level" do
    create(:app_setting, app_setting_option_id: 4)

    post_auth '/group_members', { group_member: { group_id: @group_open.id } }
    
    response.status.should eql(403)
  end   

  it "POST /group_members; attempts to join group, joining groups turned off at app level" do
    create(:app_setting, app_setting_option_id: 6)

    post_auth '/group_members', { group_member: { group_id: @group_open.id } }
    
    response.status.should eql(403)
  end  

  it "POST /group_members; create new group member, fails because user has user role that cannot join groups" do
    create(:app_setting, app_setting_option_id: 7, user_role: @user.user_role)

    post_auth '/group_members', { group_member: { group_id: @group_open.id } }
    response.status.should eql(403)
  end

  it "DELETE /group_members/:id; attempts to remove group_member, turned off at app level" do
    create(:app_setting, app_setting_option_id: 10)
    group_member = create(:group_member, user: @user, group: @group_open)

    delete_auth "/group_members/#{group_member.id}"
    response.status.should eql(403)
  end  

  it "DELETE /group_members/:id; attempts to remove group_member, turned off at app level" do
    create(:app_setting, app_setting_option_id: 12, user_role: @user.user_role)
    group_member = create(:group_member, user: @user, group: @group_open)

    delete_auth "/group_members/#{group_member.id}"
    response.status.should eql(403)
  end
  
  it "POST /group_members; attempts to join group, joining groups turned off at app level" do
    create(:app_setting, app_setting_option_id: 21)

    post_auth '/group_members', { group_member: { group_id: @group_open.id } }
    
    response.status.should eql(403)
  end  

  it "POST /group_members; create new group member (join group). Notification not created since notifications are turned off at App level." do
    create(:app_setting, app_setting_option_id: 57)
    group = create(:group, :random, :open)

    post_auth '/group_members', { group_member: { group_id: group.id } }
    response.status.should eql(201)
    json["group_member"]["id"].should be
    json["group_member"]["user"]["id"].should eq @user.id
    json["group_member"]["group"]["id"].should eq group.id
    Notification.where(user: group.owner, group: group).first.present?.should eq false
  end

end