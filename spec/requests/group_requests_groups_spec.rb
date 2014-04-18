require 'spec_helper'

describe "GroupRequestsGroups" do

  before(:all) do
    @user = create(:user)
  end

  it "GET /group_requests/groups/:user_id; receives list of requests for one user" do
    group1 = create(:group, :random)
    group2 = create(:group, :random)
    group3 = create(:group, :random)
    create(:group_request, user: @user, group: group1)
    create(:group_request, user: @user, group: group2, created_at: Time.now - 1.minute)
    create(:group_request, user: @user, group: group3)

    get_auth "/group_requests/groups"
    response.status.should eql(200)
    json["group_requests"].first["group"]["id"].should eq(group2.id)
    json["group_requests"].count.should eq(3)
  end  

  it "GET /group_requests/groups/:user_id; receives list of requests for one user, one is approved" do
    group1 = create(:group, :random)
    group2 = create(:group, :random)
    create(:group_request, user: @user, group: group1, is_approved: true)
    create(:group_request, user: @user, group: group2, created_at: Time.now - 1.minute)

    get_auth "/group_requests/groups"
    response.status.should eql(200)
    json["group_requests"].first["group"]["id"].should eq(group2.id)
    json["group_requests"].count.should eq(1)
  end  

  it "GET /group_requests/groups/:user_id; receives list of requests for one user, one is approved" do
    group1 = create(:group, :random)
    group2 = create(:group, :random)
    create(:group_request, user: @user, group: group1, is_approved: true)
    create(:group_request, user: @user, group: group2, created_at: Time.now - 1.minute, is_approved: true)

    get_auth "/group_requests/groups"
    response.status.should eql(200)
    json["group_requests"].count.should eq(0)
  end

end