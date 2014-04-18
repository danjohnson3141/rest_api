require 'spec_helper'

describe "GroupInvitesGroups" do

  before(:all) do
    @user = create(:user)
    @open_group_type = create(:group_type, :open)
    @private_group_type = create(:group_type, :private)
    @secret_group_type = create(:group_type, :secret)
  end

  it "GET /group_invites/groups; requests current user's group invites" do
    group = create(:group)
    create(:group_invite, user: @user, group: group)

    get_auth "/group_invites/groups"
    response.status.should eql(200)
    json["group_invites"].first["group"]["id"].should eq(group.id)
  end

  it "GET /group_invites/groups; requests current user's group invites, checks on alpha sort" do
    group1 = create(:group, name: "CCC")
    group2 = create(:group, name: "AAA")
    group3 = create(:group, name: "BBB")
    create(:group_invite, user: @user, group: group1)
    create(:group_invite, user: @user, group: group2)
    create(:group_invite, user: @user, group: group3)

    get_auth "/group_invites/groups"
    response.status.should eql(200)
    json["group_invites"].count.should eq 3
    json["group_invites"].first["group"]["id"].should eq(group2.id)
    json["group_invites"].second["group"]["id"].should eq(group3.id)
    json["group_invites"].third["group"]["id"].should eq(group1.id)
  end

  it "GET /group_invites/groups; requests current user's group invites, group invites for joined groups not returned" do
    group1 = create(:group, name: "CCC")
    group2 = create(:group, name: "AAA")
    group3 = create(:group, name: "BBB")
    create(:group_invite, user: @user, group: group1)
    create(:group_invite, user: @user, group: group2)
    create(:group_invite, user: @user, group: group3)
    create(:group_member, user: @user, group: group3)

    get_auth "/group_invites/groups"
    response.status.should eql(200)
    json["group_invites"].count.should eq 2
    json["group_invites"].first["group"]["id"].should eq(group2.id)
    json["group_invites"].second["group"]["id"].should eq(group1.id)
    json["group_invites"].to_s.should_not include group3.name
  end

end
