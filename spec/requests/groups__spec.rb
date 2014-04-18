require 'spec_helper'

describe 'Groups' do

  before(:all) do
    @user = create(:user)
    @group_open = create(:group, :random, :open)
    @group_private = create(:group, :random, :private)
    @group_secret = create(:group, :random, :secret)

    @user1 =  create(:user, :random, first_name: "AAA", last_name: "AAA")
    @user2 =  create(:user, :random, first_name: "BBB", last_name: "AAA")
    @user3 =  create(:user, :random, first_name: "CCC", last_name: "CCC")
    @user4 =  create(:user, :random, first_name: "DDD", last_name: "DDD")
    @user5 =  create(:user, :random, first_name: "EEE", last_name: "EEE")
    @user6 =  create(:user, :random, first_name: "FFF", last_name: "FFF")
    @user7 =  create(:user, :random, first_name: "GGG", last_name: "GGG")
    @user8 =  create(:user, :random, first_name: "HHH", last_name: "HHH")
    @user9 =  create(:user, :random, first_name: "III", last_name: "III")
    @user10 = create(:user, :random, first_name: "JJJ", last_name: "JJJ")
    @user11 = create(:user, :random, first_name: "KKK", last_name: "KKK")
  
    @group_request1 = create(:group_request, group: @group_open, user: @user9)
    @group_request2 = create(:group_request, group: @group_open, user: @user10)
    @group_request3 = create(:group_request, group: @group_open, user: @user11)
  
    @group_invite2 = create(:group_invite, group: @group_open, user: @user7)
    @group_invite1 = create(:group_invite, group: @group_open, user: @user6)
    @group_invite3 = create(:group_invite, group: @group_open, user: @user8)
    @group_invite3 = create(:group_invite, group: @group_open, user: @user2)
  
    @group_member1 = create(:group_member, group: @group_open, user: @user1)
    @group_member2 = create(:group_member, group: @group_open, user: @user2)
    @group_member3 = create(:group_member, group: @group_open, user: @user3)
    @group_member4 = create(:group_member, group: @group_open, user: @user4)
    @group_member5 = create(:group_member, group: @group_open, user: @user5)
  
    @connection1 = create(:user_connection, :approved,  sender_user: @user, recipient_user: @user1)
    @connection2 = create(:user_connection, :pending,   sender_user: @user, recipient_user: @user2)
    @connection3 = create(:user_connection, :approved,  sender_user: @user, recipient_user: @user3)

    @open_group_type = create(:group_type, :open)
  end

  it "GET /groups; receives a list of all groups visible to the user" do
    get_auth '/groups'
    
    response.status.should eql(200)
    json["groups"].count.should eq(2)
  end  


  it "GET /groups; checks if secret group is not visible, not member" do
    get_auth '/groups'

    response.status.should eql(200)
    json.to_s.should_not include(@group_secret.name)
  end

  it "GET /groups; checks if private group is visible" do
    get_auth '/groups'
    
    response.status.should eql(200)
    json.to_s.should include(@group_private.name)
  end

  it "GET /groups; checks if secret group is not visible, is member" do
    member = create(:group_member, group: @group_secret, user: @user)

    get_auth '/groups'

    response.status.should eql(200)
    json.to_s.should include(@group_secret.name)
  end

  it "GET /groups; checks if groups are alpha sort" do
    group1 = create(:group, name: "CCC")
    group2 = create(:group, name: "AAA")
    group3 = create(:group, name: "BBB")

    get_auth '/groups'

    response.status.should eql(200)
    json["groups"][0]["name"].should eq group2.name
    json["groups"][1]["name"].should eq group3.name
    json["groups"][2]["name"].should eq group1.name
  end

  it "POST /groups; attempts to create a new group but fails because doesn't include description" do
    post_auth '/groups', { group: { name: "rspec", group_type_id: @open_group_type.id, description: nil} }
    
    response.status.should eql(422)
  end

  it "POST /groups; creates a new group, user has permission" do
    post_auth '/groups', { group: { name: "rspec", group_type_id: @open_group_type.id, description: "test" } }
    
    response.status.should eql(201)
    json["group"]["name"].should eq("rspec")
    json["group"]["owner"]["id"].should eq(@user.id)
  end  

  it "POST /groups; checks that the creator of the group is also a member [hair club for men test]" do
    post_auth '/groups', { group: { name: "rspec", group_type_id: @open_group_type.id, description: "test"} }
    
    response.status.should eql(201)
    json["group"]["name"].should eq("rspec")
    json["group"]["owner"]["id"].should eq(@user.id)
    group_id = json["group"]["id"]
    GroupMember.where("group_id = #{group_id} AND user_id = #{@user.id}").count.should eq(1)
    group_mem_id = GroupMember.where("group_id = #{group_id}").first.id
    GroupMember.find(group_mem_id).user_id.should eq(@user.id)
  end

  it "GET /groups/:id; receives info on group" do
    get_auth "/groups/#{@group_open.id}"
    
    response.status.should eql(200)
    json["group"]["name"].should eq(@group_open.name)
  end  

  it "GET /groups/:id; receives info on group, private" do
    get_auth "/groups/#{@group_private.id}"
    
    response.status.should eql(200)
    json["group"]["name"].should eq(@group_private.name)
  end

  it "GET /groups/:id; receives info on group, secret, not member" do
    get_auth "/groups/#{@group_secret.id}"

    response.status.should eql(404)
  end

  it "GET /groups/:id; receives info on group, secret, is member" do
    member = create(:group_member, group: @group_secret, user: @user)

    get_auth "/groups/#{@group_secret.id}"

    response.status.should eql(200)
    json["group"]["name"].should eq(@group_secret.name)
  end

  it "GET /groups/:id; attempts to receive group that doesn't exist" do
    get_auth "/groups/0"

    response.status.should eql(404)
  end

  it "PATCH /groups/:id; updates the name and description of a group" do
    group = create(:group, owner: @user)

    patch_auth "/groups/#{group.id}", { group: { name: "Groups are Awesome", description: "QWERTY" } }

    response.status.should eql(204)
    updated_group = Group.find(group.id)
    updated_group.name.should eq("Groups are Awesome")
    updated_group.description.should eq("QWERTY")
  end

  it "PATCH /groups/:id; attempts to update a group not owner of" do
    patch_auth "/groups/#{@group_open.id}", { group: { name: "something_new" } }
    
    response.status.should eql(403)
  end

  it "PATCH /groups/:id; attempts to update a group not owner of, is secret, is not member" do
    patch_auth "/groups/#{@group_secret.id}", { group: { name: "something_new" } }
    
    response.status.should eql(404)
  end

  it "PATCH /groups/:id; attempts to update a group not owner of, is secret, is member" do
    member = create(:group_member, group: @group_secret, user: @user)

    patch_auth "/groups/#{@group_secret.id}", { group: { name: "something_new" } }
    
    response.status.should eql(403)
  end

  it "PATCH /groups/:id; updates the name of a group to blank, causing an error" do
    group = create(:group, owner: @user)

    patch_auth "/groups/#{group.id}", { group: { name: "" } }
    
    response.status.should eq(422)
  end

  it "PATCH /groups/:id; updates the description of a group to nothing, causing an error" do
    group = create(:group, owner: @user)

    patch_auth "/groups/#{group.id}", { group: { description: "" } }
    
    response.status.should eq(422)
  end

  it "PUT /groups/:id; attempts to change the group name to a non-unique" do
    group = create(:group, :open, owner: @user)

    put_auth "/groups/#{group.id}", { group: { name: @group_open.name} }
    
    response.status.should eq(422)
    Group.find(group.id).name.should eq(group.name)
  end

  it "PATCH /groups/:id; attempts to update a group that is invalid" do
    patch_auth "/groups/0", { group: { name: "something_new" } }
    
    response.status.should eql(404)
  end

  it "GET /groups/:id; group with banner ads" do
    sponsor = create(:sponsor, group: @group_open)
    banner_ad = create(:banner_ad, sponsor: sponsor)
    
    get_auth "/groups/#{@group_open.id}"
    
    json["group"]["group_sponsors"].first["banner_ads"].first["id"].should eq banner_ad.id
    json["group"]["group_sponsors"].first["banner_ads"].first["graphic_link"].should eq banner_ad.graphic_link
    json["group"]["group_sponsors"].first["banner_ads"].first["link_url"].should eq banner_ad.link_url
  end

  it "GET /groups/:id; can NOT create a post for a group they are NOT a member of" do
    get_auth "/groups/#{@group_open.id}"

    json["group"]["create_post"].should eq false
  end

  it "GET /groups/:id; can create a post for a group they are a member of" do
    group_member = create(:group_member, group: @group_open, user: @user)
    
    get_auth "/groups/#{@group_open.id}"
    
    json["group"]["create_post"].should eq true
  end

  it "GET /groups/:id; group with a sponsor" do
    sponsor = create(:sponsor, group: @group_open)
    
    get_auth "/groups/#{@group_open.id}"
    
    json["group"]["group_sponsors"].first["id"].should eq sponsor.id
  end

  it "GET /groups/:id; group without a sponsor" do
    get_auth "/groups/#{@group_open.id}"
    
    json["group"]["group_sponsor"].should eq nil
  end

  it "GET /groups/:id; group without members" do
    group = create(:group, :random)

    get_auth "/groups/#{group.id}"
    
    json["group"]["group_members"].count.should eq 0
  end

  it "GET /groups/:id; group with members and connections" do
    get_auth "/groups/#{@group_open.id}"

    json["group"]["group_members"].count.should eq 5
    json["group"]["group_members"][0]["user"]["id"].should eq @user1.id
    json["group"]["group_members"][0]["user"]["user_connections_blocked"].should eq false
    json["group"]["group_members"][0]["user"]["connection_status"]["id"].should eq @connection1.id
    json["group"]["group_members"][0]["user"]["connection_status"]["is_approved"].should eq true
    json["group"]["group_members"][0]["user"]["connection_status"]["is_approver"].should eq false
    json["group"]["group_members"][1]["user"]["id"].should eq @user2.id
    json["group"]["group_members"][0]["user"]["user_connections_blocked"].should eq false
    json["group"]["group_members"][1]["user"]["connection_status"]["id"].should eq @connection2.id
    json["group"]["group_members"][1]["user"]["connection_status"]["is_approved"].should eq false
    json["group"]["group_members"][1]["user"]["connection_status"]["is_approver"].should eq false
    json["group"]["group_members"][2]["user"]["id"].should eq @user3.id
    json["group"]["group_members"][0]["user"]["user_connections_blocked"].should eq false
    json["group"]["group_members"][2]["user"]["connection_status"]["id"].should eq @connection3.id
    json["group"]["group_members"][2]["user"]["connection_status"]["is_approved"].should eq true
    json["group"]["group_members"][2]["user"]["connection_status"]["is_approver"].should eq false
    json["group"]["group_members"][3]["user"]["id"].should eq @user4.id
    json["group"]["group_members"][4]["user"]["id"].should eq @user5.id
  end

  it "GET /groups/:id; private group with pending invites" do
    group = create(:group, :private, owner: @user)
    group_invite1 = create(:group_invite, group: group, user: @user5)
    group_invite2 = create(:group_invite, group: group, user: @user2)
    group_invite3 = create(:group_invite, group: group, user: @user7)

    get_auth "/groups/#{group.id}"
    
    json["group"]["group_invites"].count.should eq 3
    json["group"]["group_invites"][0]["user"]["id"].should eq @user2.id
    json["group"]["group_invites"][1]["user"]["id"].should eq @user5.id
    json["group"]["group_invites"][2]["user"]["id"].should eq @user7.id
  end

  it "GET /groups/:id; private group with pending invites but not group owner" do
    get_auth "/groups/#{@group_private.id}"

    json["group"]["group_invites"].count.should eq 0
  end

  it "GET /groups/; check pending condition" do
    group = create(:group, :private, owner: @user3, name: "AAAA111")
    group_request = create(:group_request, group: group, user: @user)

    get_auth "/groups/"

    json["groups"][0]["group_request_id"].should eq group_request.id
    json["groups"][0]["group_request_is_approved"].should eq false
  end  

  it "GET /groups/:id; check pending condition" do
    group = create(:group, :private, owner: @user3)
    group_request = create(:group_request, group: group, user: @user)

    get_auth "/groups/#{group.id}"

    json["group"]["group_request_id"].should eq group_request.id
    json["group"]["group_request_is_approved"].should eq false
  end

  it "GET /groups/:id; private group with pending requests" do
    group = create(:group, :private, owner: @user)
    group_request1 = create(:group_request, group: group, user: @user11)
    group_request2 = create(:group_request, group: group, user: @user3)

    get_auth "/groups/#{group.id}"

    json["group"]["group_requests"].count.should eq 2
    json["group"]["group_requests"][0]["user"]["id"].should eq @user3.id
    json["group"]["group_requests"][1]["user"]["id"].should eq @user11.id
  end

  it "GET /groups/:id; private group with pending requests but not group owner" do
    get_auth "/groups/#{@group_private.id}"

    json["group"]["group_requests"].count.should eq 0
  end

  xit "GET /groups; attempts to receive a list of all visible groups, should return 0 because of app setting" do
    create(:app_setting, app_setting_option_id: 4)
    
    get_auth '/groups'

    response.status.should eql(200)
    json["groups"].count.should eq(0)
  end  

  xit "GET /groups; attempts to receive a list of all visible groups, should return 1 because of app setting and membership" do
    member = create(:group_member, group: @group_open, user: @user)
    create(:app_setting, app_setting_option_id: 4)
    
    get_auth '/groups'

    response.status.should eql(200)
    json["groups"].count.should eq(1)
  end

  it "GET /groups/:id; group with members who hide themselves from the list" do
    create(:app_setting, app_setting_option_id: 18, user: @user1)
    create(:app_setting, app_setting_option_id: 18, user: @user4)
    
    get_auth "/groups/#{@group_open.id}"

    json["group"]["group_members"].count.should eq 3
    json["group"]["group_members"][0]["user"]["id"].should eq @user2.id
    json["group"]["group_members"][0]["user"]["user_connections_blocked"].should eq false
    json["group"]["group_members"][0]["user"]["connection_status"]["id"].should eq @connection2.id
    json["group"]["group_members"][0]["user"]["connection_status"]["is_approved"].should eq false
    json["group"]["group_members"][0]["user"]["connection_status"]["is_approver"].should eq false

    json["group"]["group_members"][1]["user"]["id"].should eq @user3.id
    json["group"]["group_members"][1]["user"]["user_connections_blocked"].should eq false
    json["group"]["group_members"][1]["user"]["connection_status"]["id"].should eq @connection3.id
    json["group"]["group_members"][1]["user"]["connection_status"]["is_approved"].should eq true
    json["group"]["group_members"][1]["user"]["connection_status"]["is_approver"].should eq false

    json["group"]["group_members"][2]["user"]["id"].should eq @user5.id
    json["group"]["group_members"][2]["user"]["user_connections_blocked"].should eq false
    json["group"]["group_members"][2]["user"]["connection_status"].should eq nil
  end

  it "GET /groups/:id; group with members when group list is disabled" do
    create(:app_setting, app_setting_option_id: 15, group: @group_open)
    get_auth "/groups/#{@group_open.id}"

    json["group"]["group_members"].count.should eq 0
  end

  it "GET /groups/:id; group with members and connections turned off" do
    create(:app_setting, app_setting_option_id: 47)
    
    get_auth "/groups/#{@group_open.id}"

    json["group"]["group_members"].count.should eq 5
    json["group"]["group_members"][0]["user"]["id"].should eq @user1.id
    json["group"]["group_members"][0]["user"]["user_connections_blocked"].should eq true
    json["group"]["group_members"][0]["user"]["connection_status"].should eq nil
    json["group"]["group_members"][1]["user"]["id"].should eq @user2.id
    json["group"]["group_members"][1]["user"]["user_connections_blocked"].should eq true
    json["group"]["group_members"][1]["user"]["connection_status"].should eq nil
    json["group"]["group_members"][2]["user"]["id"].should eq @user3.id
    json["group"]["group_members"][2]["user"]["user_connections_blocked"].should eq true
    json["group"]["group_members"][2]["user"]["connection_status"].should eq nil
    json["group"]["group_members"][3]["user"]["id"].should eq @user4.id
    json["group"]["group_members"][4]["user"]["id"].should eq @user5.id
  end

  xit "GET /groups/:id; attempts to receive info on one group, 404s because of app setting" do
    create(:app_setting, app_setting_option_id: 4)
    get_auth "/groups/#{@group_open.id}"
    
    response.status.should eql(404)
  end  

  it "GET /groups/:id; attempts to receive info on one group, succeeds because of membership" do
    create(:app_setting, app_setting_option_id: 4)
    member = create(:group_member, group: @group_open, user: @user)
    
    get_auth "/groups/#{@group_open.id}"
    
    response.status.should eql(200)
    json["group"]["name"].should eq(@group_open.name)
  end  

  it "GET /groups/:id; attempts to receive info on one group, succeeds because of membership" do
    create(:app_setting, app_setting_option_id: 4)
    member = create(:group_member, group: @group_open, user: @user)
    
    get_auth "/groups/#{@group_open.id}"
    
    response.status.should eql(200)
    json["group"]["name"].should eq(@group_open.name)
  end  

  xit "GET /groups/:id; attempts to receive info on one group, returns 1 because of app setting (5)" do
    create(:app_setting, app_setting_option_id: 5, user_role: @user.user_role)
    group1 = create(:group, :open)
    group2 = create(:group, :private)
    group3 = create(:group, :open)
    member = create(:group_member, group: group3, user: @user)
    
    get_auth "/groups/"
    
    json["groups"].count.should eq(1)
    response.status.should eql(200)
    json["groups"][0]["name"].should eq(group3.name)
  end

  it "POST /groups; attempts to create group, fails because of app setting (8)" do
    create(:app_setting, app_setting_option_id: 8)

    post_auth '/groups', { group: { name: "rspec", group_type_id: @open_group_type.id, description: "test" } }
    
    response.status.should eql(403)
  end  

  it "POST /groups; attempts to create group, fails because of app setting (4)" do
    create(:app_setting, app_setting_option_id: 4)

    post_auth '/groups', { group: { name: "rspec", group_type_id: @open_group_type.id, description: "test" } }
    
    response.status.should eql(403)
  end  

  it "POST /groups; attempts to create group, fails because of app setting (2)" do
    create(:app_setting, app_setting_option_id: 2)

    post_auth '/groups', { group: { name: "rspec", group_type_id: @open_group_type.id, description: "test" } }

    response.status.should eql(403)
  end    

  it "POST /groups; attempts to create group, fails because of app setting (21)" do
    create(:app_setting, app_setting_option_id: 21)

    post_auth '/groups', { group: { name: "rspec", group_type_id: @open_group_type.id, description: "test" } }

    response.status.should eql(403)
  end  

  it "POST /groups; creates a new group, user doesn't have permission" do
    create(:app_setting, app_setting_option_id: 9, user_role: @user.user_role)
    
    post_auth '/groups', { group: { name: "rspec", group_type_id: @open_group_type.id, description: "test" } }
    
    response.status.should eql(403)
  end

end