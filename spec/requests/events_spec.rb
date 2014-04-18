require 'spec_helper'

describe 'Events' do

  before(:all) do
    @user = create(:user)
    @user2 = create(:user, :random)
    @user_sponsor = create(:user, :random, :sponsor)
    @group = create(:group, :open)
    @group_member = create(:group_member, user: @user, group: @group)

    @user_staff1 = create(:user, :random, first_name: 'staff user 1')
    @user_staff2 = create(:user, :random, first_name: 'staff user 2')
    @user_staff3 = create(:user, :random, first_name: 'staff user 3')

    @event1 = create(:event, :random, :today  , group: @group)
    @event2 = create(:event, :random, :past   , group: @group)
    @event3 = create(:event, :random, :future , group: @group)

    @event_user_staff1 = create(:event_staff_user, event: @event1, user: @user_staff1)
    @event_user_staff2 = create(:event_staff_user, event: @event1, user: @user_staff2)
    @event_user_staff3 = create(:event_staff_user, event: @event2, user: @user_staff3)
    @event_eval1 = create(:event_evaluation, :user_all, event: @event1, survey_link: "http://www.surveygizmo.com/event/#{@event1.id}/survey_1", display_rank: 2, created_at: Time.now - 12.hours)
    @event_eval2 = create(:event_evaluation, :user_all, event: @event1, survey_link: "http://www.surveygizmo.com/event/#{@event1.id}/survey_2", display_rank: 1, created_at: Time.now - 48.hours)
    @event_eval3 = create(:event_evaluation, :sponsor,  event: @event1, survey_link: "http://www.surveygizmo.com/event/#{@event1.id}/sponsor_survey", display_rank: 1, created_at: Time.now - 48.hours)
  end

  it "GET /events/:id; returns 1 record, checks event evaluations, app setting is ON, order by display_rank, created_at, evals not for current user's user role not returned" do
    sponsor = create(:sponsor, event: @event1)
    banner_ad = create(:banner_ad, sponsor: sponsor)

    get_auth "/events/#{@event1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["event_evaluations"].first["id"].should eq @event_eval2.id
    json["event"]["event_evaluations"].first["survey_link"].should eq @event_eval2.survey_link
    json["event"]["event_evaluations"].second["id"].should eq @event_eval1.id
    json["event"]["event_evaluations"].second["survey_link"].should eq @event_eval1.survey_link
    json["event"]["event_evaluations"].to_s.should_not include "http://www.surveygizmo.com/event/#{@event1.id}/sponsor_survey"
    json["event"]["event_evaluations"].count.should eq (2)
  end

  it "GET /events/:id; event_notes turned on" do
    get_auth "/events/#{@event1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["id"].should eq @event1.id
    json["event"]["allow_notes"].should eq true
  end

  it "GET /events/:id; event_notes turned off - Event Setting (147)" do
    create(:app_setting, app_setting_option_id: 147, event: @event1)

    get_auth "/events/#{@event1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["id"].should eq @event1.id
    json["event"]["allow_notes"].should eq false
  end

  it "GET /events/:id; event_notes turned off - UserRole Setting (148)" do
    create(:app_setting, app_setting_option_id: 148, user_role: @user.user_role)

    get_auth "/events/#{@event1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["id"].should eq @event1.id
    json["event"]["allow_notes"].should eq false
  end

  it "GET /events/:id; event_bookmarks turned on" do
    get_auth "/events/#{@event1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["id"].should eq @event1.id
    json["event"]["allow_bookmarks"].should eq true
  end

  it "GET /events/:id; event_bookmarks turned off - Event Setting (150)" do
    create(:app_setting, app_setting_option_id: 150, event: @event1)

    get_auth "/events/#{@event1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["id"].should eq @event1.id
    json["event"]["allow_bookmarks"].should eq false
  end

  it "GET /events/:id; event_bookmarks turned off - User Setting (151)" do
    create(:app_setting, app_setting_option_id: 151, user_role: @user.user_role)

    get_auth "/events/#{@event1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["id"].should eq @event1.id
    json["event"]["allow_bookmarks"].should eq false
  end

  it "GET /events/:id; returns 1 record on multiple record possibilities, checks for staff" do
    get_auth "/events/#{@event1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["id"].should eq @event1.id
    json["event"]["event_staff"].to_s.should include @user_staff1.first_name, @user_staff2.first_name
    json["event"]["event_staff"].to_s.should_not include @user_staff3.first_name
  end

  xit "GET /events/:id; checks user_today_event, event is today" do
    event_user1 = create(:event_user, :registered, user: @user, event: @event1)

    get_auth "/events/#{@event1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["id"].should eq @event1.id
    json["event"]["user_today_event"].should eq true
  end 

  it "GET /events/:id; checks user_today_event, event is past" do
    event_user1 = create(:event_user, :registered, user: @user, event: @event2)

    get_auth "/events/#{@event2.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["id"].should eq @event2.id
    json["event"]["user_today_event"].should eq false
  end

  it "GET /events/:id; checks user_today_event, event is future" do
    event_user1 = create(:event_user, :registered, user: @user, event: @event3)

    get_auth "/events/#{@event3.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["id"].should eq @event3.id
    json["event"]["user_today_event"].should eq false
  end

  it "GET /events/:id; checks user_today_event, event is today, no event_user record" do
    get_auth "/events/#{@event1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["id"].should eq @event1.id
    json["event"]["user_today_event"].should eq false
  end

  it "GET /events/all; get all events for active user (3 in this case), user must be member to see events" do
    event4 = create(:event, :random, :future)
    event_user1 = create(:event_user, :attended, event: @event1, user: @user)
    event_user2 = create(:event_user, :registered, event: @event2, user: @user)
    event_user3 = create(:event_user, :invited, event: @event3, user: @user)
    event_session = create(:event_session, :random, event: event4)
    speaker = create(:event_speaker, :random, user: @user, first_name: @user.first_name, last_name: @user.last_name, event_session: event_session)

    get_auth "/events/all"

    response.status.should eql(200)
    json["events"].count.should eq(3)
    json["events"].first['id'].should eq @event3.id
    json["events"].second['id'].should eq @event1.id
    json["events"].third['id'].should eq @event2.id
  end

  it "GET /events/upcoming; check order of events" do
    event4 = create(:event, :random, begin_date: Time.now + 12.day, end_date: Time.now + 13.day, group: @group )
    event5 = create(:event, :random, begin_date: Time.now + 40.day, end_date: Time.now + 41.day, group: @group, name: 'ZZZ',  )
    event6 = create(:event, :random, begin_date: Time.now + 30.day, end_date: Time.now + 31.day, group: @group )
    event7 = create(:event, :random, begin_date: Time.now + 20.day, end_date: Time.now + 21.day, group: @group )
    event8 = create(:event, :random, begin_date: Time.now + 40.day, end_date: Time.now + 41.day, group: @group, name: 'AAA',  )

    get_auth "/events/upcoming"

    response.status.should eql(200)
    json["events"].count.should eq(7)
    json["events"][0]["id"].should eq @event1.id
    json["events"][1]["id"].should eq @event3.id
    json["events"][2]["id"].should eq event4.id
    json["events"][3]["id"].should eq event7.id
    json["events"][4]["id"].should eq event6.id
    json["events"][5]["id"].should eq event8.id
    json["events"][6]["id"].should eq event5.id
  end  

  it "GET /events/upcoming; checks that upcoming events, not member of group, but event user still return" do
    group_new = create(:group, :private)
    event_new = create(:event, :random, :future, name: "ABCDEFGH", group: group_new)
    event_user_new = create(:event_user, event: event_new, user: @user)

    get_auth "/events/upcoming"

    response.status.should eql(200)
    json["events"].to_s.should include event_new.name
  end  

  it "GET /events/past; checks that past events, not member of group, but event user still return" do
    group_new = create(:group, :private)
    event_new = create(:event, :random, :past, name: "ABCDEFGH", group: group_new)
    event_user_new = create(:event_user, event: event_new, user: @user)

    get_auth "/events/past"

    response.status.should eql(200)
    json["events"].to_s.should include event_new.name
  end

  it "GET /events/past/:user_id; check order of events" do
    event4 = create(:event, :random, begin_date: Time.now - 13.day, end_date: Time.now - 12.day, group: @group )
    event5 = create(:event, :random, begin_date: Time.now - 41.day, end_date: Time.now - 40.day, group: @group, name: 'ZZZ',  )
    event6 = create(:event, :random, begin_date: Time.now - 31.day, end_date: Time.now - 30.day, group: @group )
    event7 = create(:event, :random, begin_date: Time.now - 21.day, end_date: Time.now - 20.day, group: @group )
    event8 = create(:event, :random, begin_date: Time.now - 41.day, end_date: Time.now - 40.day, group: @group, name: 'AAA',  )

    get_auth "/events/past"

    response.status.should eql(200)
    json["events"].count.should eq(7)
    json["events"][0]["id"].should eq @event1.id
    json["events"][1]["id"].should eq @event2.id
    json["events"][2]["id"].should eq event4.id
    json["events"][3]["id"].should eq event7.id
    json["events"][4]["id"].should eq event6.id
    json["events"][5]["id"].should eq event8.id
    json["events"][6]["id"].should eq event5.id
  end

  it "GET /events/all; check order of events" do
    event4 = create(:event, :random, begin_date: Time.now + 13.day, end_date: Time.now + 14.day, group: @group )
    event5 = create(:event, :random, begin_date: Time.now - 41.day, end_date: Time.now - 40.day, group: @group, name: 'ZZZ',  )
    event6 = create(:event, :random, begin_date: Time.now + 31.day, end_date: Time.now + 32.day, group: @group )
    event7 = create(:event, :random, begin_date: Time.now - 21.day, end_date: Time.now - 20.day, group: @group )
    event8 = create(:event, :random, begin_date: Time.now - 41.day, end_date: Time.now - 40.day, group: @group, name: 'AAA',  )

    event_user1 = create(:event_user, event: @event1,  user: @user)
    event_user2 = create(:event_user, event: @event3,  user: @user)
    event_user3 = create(:event_user, event: event5,  user: @user)
    event_user4 = create(:event_user, event: event7,  user: @user)

    event_follower1 = create(:event_follower, user: @user, event: @event2)
    event_follower2 = create(:event_follower, user: @user, event: event4)
    event_follower3 = create(:event_follower, user: @user, event: event6)
    event_follower4 = create(:event_follower, user: @user, event: event8)

    get_auth "/events/all"

    response.status.should eql(200)
    json["events"].count.should eq(8)
    json["events"][0]["id"].should eq event6.id
    json["events"][1]["id"].should eq event4.id
    json["events"][2]["id"].should eq @event3.id
    json["events"][3]["id"].should eq @event1.id
    json["events"][4]["id"].should eq @event2.id
    json["events"][5]["id"].should eq event7.id
    json["events"][6]["id"].should eq event8.id
    json["events"][7]["id"].should eq event5.id
  end

  it "GET /events/:id; get a 404 status when using invalid event" do
    get_auth "/events/0"

    response.status.should eql(404)
  end

  it "GET /events/:id; returns 1 record, checks event evaluations, app setting is OFF, no evals returned" do
    create(:app_setting, app_setting_option_id: 157, user_role: @user.user_role)

    get_auth "/events/#{@event1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["event_evaluations"].should eq []
  end

  it "GET /events/:id; returns 404 because event section turned off for app" do
    create(:app_setting, app_setting_option_id: 125)
    
    get_auth "/events/#{@event1.id}"

    response.status.should eql(404)
  end

  it "GET /events/:id; returns 404 because event section turned off for user_role" do
    create(:app_setting, app_setting_option_id: 126, user_role: @user.user_role)
    
    get_auth "/events/#{@event1.id}"

    response.status.should eql(404)
  end

  it "GET /events/all; returns 404 because event section turned off for app" do
    create(:app_setting, app_setting_option_id: 125)
    
    get_auth "/events/all"

    response.status.should eql(404)
  end

  it "GET /events/all; returns 404 because event section turned off for user_role" do
    create(:app_setting, app_setting_option_id: 126, user_role: @user.user_role)
    
    get_auth "/events/all"

    response.status.should eql(404)
  end

  it "GET /events/upcoming; returns 404 because event section turned off for app" do
    create(:app_setting, app_setting_option_id: 125)
    
    get_auth "/events/upcoming"

    response.status.should eql(404)
  end

  it "GET /events/upcoming; returns 404 because event section turned off for user_role" do
    create(:app_setting, app_setting_option_id: 126, user_role: @user.user_role)
    
    get_auth "/events/upcoming"

    response.status.should eql(404)
  end

  it "GET /events/past; returns 404 because event section turned off for app" do
    create(:app_setting, app_setting_option_id: 125)
    
    get_auth "/events/past"

    response.status.should eql(404)
  end

  it "GET /events/past; returns 404 because event section turned off for user_role" do
    create(:app_setting, app_setting_option_id: 126, user_role: @user.user_role)
    get_auth "/events/past"

    response.status.should eql(404)
  end

  xit "GET /events/:id; returns todays event; flag is off because of app setting (131)" do
    create(:app_setting, app_setting_option_id: 131)
    event_user1 = create(:event_user, :registered, user: @user, event: @event1)

    get_auth "/events/#{@event1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event"]["id"].should eq @event1.id
    json["event"]["user_today_event"].should eq false
  end

end