require 'spec_helper'

describe 'Sponsor' do

  before(:all) do
    @user = create(:user)
    @user2 = create(:user, :random, first_name: "ZZZ", last_name: "AAA")
    @user3 = create(:user, :random, first_name: "AAA", last_name: "BBB")
    @user4 = create(:user, :random, first_name: "AAA", last_name: "AAA")

    @event1 = create(:event, :random)
    @event2 = create(:event, :random)
    @event3 = create(:event, :random)
    @event4 = create(:event, :random)
    @event5 = create(:event, :random)

    @sponsor_type1 = create(:sponsor_type, name: 's1', display_rank: 2)
    @sponsor_type2 = create(:sponsor_type, name: 's2', display_rank: 1)
    @sponsor_type3 = create(:sponsor_type, name: 's3', display_rank: 3)
    @sponsor_type4 = create(:sponsor_type, name: 's4', display_rank: 4)
    @sponsor_type5 = create(:sponsor_type, name: 's5', display_rank: 5)

    @app_sponsor1 = create(:sponsor, name: "Zzzz_app", sponsor_type: @sponsor_type1)
    @app_sponsor2 = create(:sponsor, name: "Cccc_app", sponsor_type: @sponsor_type2)
    @app_sponsor3 = create(:sponsor, name: "Bbbb_app", sponsor_type: @sponsor_type3)
    @app_sponsor4 = create(:sponsor, name: "Xxxx_app", sponsor_type: @sponsor_type4)
    @app_sponsor5 = create(:sponsor, name: "Aaaa_app", sponsor_type: @sponsor_type5)

    @group_sponsor1 = create(:sponsor, :group, name: "Zzzz_group", sponsor_type: @sponsor_type1)
    @group_sponsor2 = create(:sponsor, :group, name: "Cccc_group", sponsor_type: @sponsor_type2)
    @group_sponsor3 = create(:sponsor, :group, name: "Bbbb_group", sponsor_type: @sponsor_type3)
    @group_sponsor4 = create(:sponsor, :group, name: "Xxxx_group", sponsor_type: @sponsor_type4)
    @group_sponsor5 = create(:sponsor, :group, name: "Aaaa_group", sponsor_type: @sponsor_type5)

    @event_sponsor1 = create(:sponsor, :event, name: "Zzzz_event", sponsor_type: @sponsor_type1)
    @event_sponsor2 = create(:sponsor, :event, name: "Cccc_event", sponsor_type: @sponsor_type2)
    @event_sponsor3 = create(:sponsor, :event, name: "Bbbb_event", sponsor_type: @sponsor_type3)
    @event_sponsor4 = create(:sponsor, :event, name: "Xxxx_event", sponsor_type: @sponsor_type4)
    @event_sponsor5 = create(:sponsor, :event, name: "Aaaa_event", sponsor_type: @sponsor_type5)

    @sponsor1_user1 = create(:sponsor_user, user: @user2, sponsor: @event_sponsor1)
    @sponsor1_user2 = create(:sponsor_user, user: @user3, sponsor: @event_sponsor1)
    @sponsor1_user3 = create(:sponsor_user, user: @user4, sponsor: @event_sponsor1)
    @sponsor1_attachment1 = create(:sponsor_attachment, sponsor: @event_sponsor1)
    @sponsor1_attachment2 = create(:sponsor_attachment, sponsor: @event_sponsor1)

    @user_connection1 = create(:user_connection, :approved, sender_user: @user, recipient_user: @user4)
  end

  it "GET /sponsors; get all sponsors" do
    get_auth "/sponsors"

    response.status.should eql(200)
    json["sponsors"].count.should eq(15)
  end

  it "GET /sponsors/:id; checks on sponsor of secret group, not member, should 404" do
    secret_group = create(:group, :secret)
    secret_sponsor = create(:sponsor, group: secret_group)

    get_auth "/sponsors/#{secret_sponsor.id}"

    response.status.should eql(404)
  end  

  xit "GET /sponsors/:id; checks for sponsor posts" do
    post = create(:post, :event, sponsor: @event_sponsor1)

    get_auth "/sponsors/#{@event_sponsor1.id}"

    response.status.should eql(200)
    json["sponsor"]["posts"][0]["id"].should eq post.id
  end

  it "GET /sponsors/:id; checks on sponsor of secret group, is member, returns sponsor" do
    secret_group = create(:group, :secret)
    secret_sponsor = create(:sponsor, group: secret_group)
    secret_member = create(:group_member, user: @user, group: secret_group)

    get_auth "/sponsors/#{secret_sponsor.id}"

    response.status.should eql(200)
    json["sponsor"]["id"].should eq secret_sponsor.id
  end

  it "GET /sponsors/:id; checks on sponsor of secret event, not member, not user, should 404" do
    secret_group = create(:group, :secret)
    secret_event = create(:event, :random, group: secret_group)
    secret_sponsor = create(:sponsor, event: secret_event)

    get_auth "/sponsors/#{secret_sponsor.id}"

    response.status.should eql(404)
  end

  it "GET /sponsors/:id; checks on sponsor of secret event, is member, not user, returns sponsor" do
    secret_group = create(:group, :secret)
    secret_event = create(:event, :random, group: secret_group)
    secret_sponsor = create(:sponsor, event: secret_event)
    secret_member = create(:group_member, user: @user, group: secret_group)

    get_auth "/sponsors/#{secret_sponsor.id}"

    response.status.should eql(200)
    json["sponsor"]["id"].should eq secret_sponsor.id
  end

  it "GET /sponsors/:id; checks on sponsor of secret event, not member, is user, returns sponsor" do
    secret_group = create(:group, :secret)
    secret_event = create(:event, :random, group: secret_group)
    create(:group_member, group: secret_group, user: @user)
    secret_sponsor = create(:sponsor, event: secret_event)
    secret_event_user = create(:event_user, user: @user, event: secret_event)

    get_auth "/sponsors/#{secret_sponsor.id}"

    response.status.should eql(200)
    json["sponsor"]["id"].should eq secret_sponsor.id
  end

  it "GET /sponsors/app; check sort order. Sponsor_type.display_rank, sponsor.name." do
    get_auth "/sponsors/app"

    response.status.should eql(200)
    json["sponsors"].count.should eq(5)
    json["sponsors"][0]["name"].should eq @app_sponsor2.name
    json["sponsors"][1]["name"].should eq @app_sponsor1.name
    json["sponsors"][2]["name"].should eq @app_sponsor3.name
    json["sponsors"][3]["name"].should eq @app_sponsor4.name
    json["sponsors"][4]["name"].should eq @app_sponsor5.name
  end

  it "GET /sponsors/group; check sort order. Sponsor_type.display_rank, sponsor.name." do
    get_auth "/sponsors/group"

    response.status.should eql(200)
    json["sponsors"].count.should eq(5)
    json["sponsors"][0]["name"].should eq @group_sponsor2.name
    json["sponsors"][1]["name"].should eq @group_sponsor1.name
    json["sponsors"][2]["name"].should eq @group_sponsor3.name
    json["sponsors"][3]["name"].should eq @group_sponsor4.name
    json["sponsors"][4]["name"].should eq @group_sponsor5.name
  end

  it "GET /sponsors/event; check sort order. Sponsor_type.display_rank, sponsor.name." do
    get_auth "/sponsors/event"

    response.status.should eql(200)
    json["sponsors"].count.should eq(5)
    json["sponsors"][0]["name"].should eq @event_sponsor2.name
    json["sponsors"][1]["name"].should eq @event_sponsor1.name
    json["sponsors"][2]["name"].should eq @event_sponsor3.name
    json["sponsors"][3]["name"].should eq @event_sponsor4.name
    json["sponsors"][4]["name"].should eq @event_sponsor5.name
  end

  it "GET /sponsors/:id; returns 403 when trying to show app sponsor with app sponsors turned off at app level" do
    create(:app_setting, app_setting_option_id: 1) # Main – Turn off Sponsors section & App banner ads

    get_auth "/sponsors/#{@app_sponsor1.id}"

    response.status.should eql(403)
  end

  it "GET /sponsors/:id; permission check, event sponsors are disabled for this event, 403 returned." do
    event_disabled = create(:event, :random)
    disabled_sponsor = create(:sponsor, event: event_disabled)
    create(:app_setting, app_setting_option_id: 138, event: event_disabled) # Hide Event – Sponsors

    get_auth "/sponsors/#{disabled_sponsor.id}"

    response.status.should eql(403)
  end

  xit "GET /sponsors/:id; permission check, event sponsors are disabled for current user, 403 returned." do
    create(:app_setting, app_setting_option_id: 139, event: @event1, user_role: @user.user_role) # Hide Event – Sponsors

    get_auth "/sponsors/#{@event_sponsor1.id}"

    response.status.should eql(403)
  end

  it "GET /sponsors/:id; returns 1 sponsor record. Sponsor_users should be alpha order (A-Z: last_name, first_name). Sponsor attachments also returned" do
    get_auth "/sponsors/#{@event_sponsor1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["sponsor"]["id"].should eq @event_sponsor1.id
    json["sponsor"]["sponsor_contact_users"].first["id"].should eq @user4.id
    json["sponsor"]["sponsor_contact_users"].second["id"].should eq @user2.id
    json["sponsor"]["sponsor_contact_users"].third["id"].should eq @user3.id
    json["sponsor"]["sponsor_attachments"].to_s.should include @sponsor1_attachment1.url, @sponsor1_attachment2.url
  end

  # Shy sponsor test
  it "GET /sponsors/:id; returns 1 sponsor record. Sponsors that have set themselves to 'do not show on lists' should not be returned." do
    create(:app_setting, app_setting_option_id: 18, user: @user2)

    get_auth "/sponsors/#{@event_sponsor1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["sponsor"]["id"].should eq @event_sponsor1.id
    json["sponsor"]["sponsor_contact_users"].first["id"].should eq @user4.id
    json["sponsor"]["sponsor_contact_users"].second["id"].should eq @user3.id
    json["sponsor"]["sponsor_contact_users"].to_s.should_not include @user2.first_name
    json["sponsor"]["sponsor_attachments"].to_s.should include @sponsor1_attachment1.url, @sponsor1_attachment2.url
  end

  # Sponsor connected to current user test
  it "GET /sponsors/:id; returns 1 sponsor record. Sponsors connected to current user should have connection information returned" do
    user_connection2 = create(:user_connection, :pending, recipient_user: @user, sender_user: @user2)

    get_auth "/sponsors/#{@event_sponsor1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["sponsor"]["id"].should eq @event_sponsor1.id
    json["sponsor"]["sponsor_contact_users"].first["id"].should eq @user4.id
    json["sponsor"]["sponsor_contact_users"].first["connection_status"]["id"].should eq @user_connection1.id
    json["sponsor"]["sponsor_contact_users"].first["connection_status"]["is_approved"].should eq true
    json["sponsor"]["sponsor_contact_users"].first["connection_status"]["is_approver"].should eq false
    json["sponsor"]["sponsor_contact_users"].second["id"].should eq @user2.id
    json["sponsor"]["sponsor_contact_users"].second["connection_status"]["id"].should eq user_connection2.id
    json["sponsor"]["sponsor_contact_users"].second["connection_status"]["is_approved"].should eq false
    json["sponsor"]["sponsor_contact_users"].second["connection_status"]["is_approver"].should eq true
    json["sponsor"]["sponsor_contact_users"].third["id"].should eq @user3.id
    json["sponsor"]["sponsor_contact_users"].third["connection_status"].should eq nil
  end

  it "GET /sponsors/:id; get a 404 status when using invalid app sponsor" do
    get_auth "/sponsors/0"
    response.status.should eql(404)
  end

end
