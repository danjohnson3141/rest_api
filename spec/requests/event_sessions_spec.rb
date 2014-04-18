require 'spec_helper'

describe 'EventSessions' do

  before(:all) do
    @user = create(:user)
    @event = create(:event, :random)
    @event_user = create(:event_user, :registered, user: @user, event: @event)
    @event_session1 = create(:event_session, :random, event: @event, start_date_time: '2014-01-01 14:00:00', display_rank: 1, name: 'A')
    @event_session2 = create(:event_session, :random, event: @event, start_date_time: '2014-01-01 16:00:00', display_rank: 2, name: 'C')
    @event_session3 = create(:event_session, :random, event: @event, start_date_time: '2014-01-01 15:00:00', display_rank: 1, name: 'B')
    @event_session4 = create(:event_session, :random, event: @event, start_date_time: '2014-01-01 14:00:00', display_rank: 1, name: 'Z')
    @event_session5 = create(:event_session, :random, event: @event, start_date_time: '2014-01-01 15:00:00', display_rank: 1, name: 'Y')
    @event_session6 = create(:event_session, :random, event: @event, start_date_time: '2014-01-01 16:00:00', display_rank: 1, name: 'X')
    @event_session7 = create(:event_session, :random, event: @event, start_date_time: '2014-01-01 14:00:00', display_rank: 1, name: 'QQQ')
    @user_schedule1 = create(:event_user_schedule, event_session: @event_session1, event_user: @event_user, creator: @user)
    @user_schedule2 = create(:event_user_schedule, event_session: @event_session2, event_user: @event_user, creator: @user)
    @user_schedule3 = create(:event_user_schedule, event_session: @event_session3, event_user: @event_user, creator: @user)
    @user_schedule4 = create(:event_user_schedule, event_session: @event_session4, event_user: @event_user, creator: @user)
    @user_schedule5 = create(:event_user_schedule, event_session: @event_session5, event_user: @event_user, creator: @user)
    @user_schedule6 = create(:event_user_schedule, event_session: @event_session6, event_user: @event_user, creator: @user)
    @event_note1 = create(:event_note, :random, event_session: @event_session2, creator: @user)
    @event_note2 = create(:event_note, :random, event_session: @event_session3, creator: @user)
    @event_bookmark1 = create(:event_bookmark, event_session: @event_session1, creator: @user)
    @event_bookmark2 = create(:event_bookmark, event_session: @event_session3, creator: @user)
    @event_session_eval1 = create(:event_session_evaluation, event_session: @event_session1, survey_link: "http://www.surveygizmo.com/event/#{@event_session1.event.id}/event_session/#{@event_session1.id}/survey_1", display_rank: 2, created_at: Time.now - 12.hours)
    @event_session_eval2 = create(:event_session_evaluation, event_session: @event_session1, survey_link: "http://www.surveygizmo.com/event/#{@event_session1.event.id}/event_session/#{@event_session1.id}/survey_2", display_rank: 1, created_at: Time.now - 48.hours)
  end

  it "GET /event_sessions/:id; event session evaluation(s) should be returned by display rank order" do
    user_speaker = create(:user, :random)
    event_speaker = create(:event_speaker, :random, user: user_speaker, event_session: @event_session1)

    get_auth "/event_sessions/#{@event_session1.id}"

    response.status.should eql(200)

    json["event_session"]["event_session_evaluations"][0]['id'].should eq @event_session_eval2.id
    json["event_session"]["event_session_evaluations"][0]['survey_link'].should eq @event_session_eval2.survey_link
    json["event_session"]["event_session_evaluations"][1]['id'].should eq @event_session_eval1.id
    json["event_session"]["event_session_evaluations"][1]['survey_link'].should eq @event_session_eval1.survey_link
  end

  it "GET /event_sessions/:id; session post title/body overrides event session name/description" do
    event_session = create(:event_session, name: 'Session Name', description: "Session Description", event: @event)
    post = create(:post, event_session: event_session, title: "Post Title", body: "Post Body")

    get_auth "/event_sessions/#{event_session.id}"
    response.status.should eql(200)
    json["event_session"]['name'].should eq post.title
    json["event_session"]['description'].should eq post.body
  end

  it "GET /event_sessions/my_schedule/:event_id;" do
    get_auth "/event_sessions/my_schedule/#{@event.id}"

    response.status.should eql(200)
    json["event_sessions"].count.should eq(6)
    json["event_sessions"].first['id'].should eq @event_session1.id
    json["event_sessions"].second['id'].should eq @event_session4.id
    json["event_sessions"].third['id'].should eq @event_session3.id
    json["event_sessions"].fourth['id'].should eq @event_session5.id
    json["event_sessions"].fifth['id'].should eq @event_session6.id
  end

  it "GET /event_sessions/:id; 'show_my_schedule' set to OFF at App level." do
    create(:app_setting, app_setting_option_id: 169)
    event_note3 = create(:event_note, :random, event_session: @event_session1, creator: @user)

    get_auth "/event_sessions/#{@event_session1.id}"
    response.status.should eql(200)
    json["event_session"]["name"].should eq @event_session1.name
    json["event_session"]["event_note_id"].should eq event_note3.id
    json["event_session"]["event_bookmark_id"].should eq @event_bookmark1.id
    json["event_session"]["event_schedule_id"].should eq nil
    json["event_session"]["show_my_schedule"].should eq false
  end


  it "GET /event_sessions/:id; 'show_my_schedule' is set ON." do
    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json["event_session"]['name'].should eq @event_session1.name
    json["event_session"]['event_note_id'].should eq nil
    json["event_session"]['event_bookmark_id'].should eq @event_bookmark1.id
    json["event_session"]['event_schedule_id'].should eq @user_schedule1.id
  end

  it "GET /event_sessions/:id; with permission, checks comment count" do
    event_note3 = create(:event_note, :random, event_session: @event_session1, creator: @user)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json["event_session"]["comment_count"].should eq 1
    json["event_session"]['name'].should eq @event_session1.name
    json["event_session"]['event_note_id'].should eq event_note3.id
    json["event_session"]['event_bookmark_id'].should eq @event_bookmark1.id
    json["event_session"]['event_schedule_id'].should eq @user_schedule1.id
  end

  it "GET /event_sessions/:id; with 'show_event_notes' set to ON." do
    event_note3 = create(:event_note, :random, event_session: @event_session1, creator: @user)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json["event_session"]['name'].should eq @event_session1.name
    json["event_session"]['event_note_id'].should eq event_note3.id
    json["event_session"]['event_bookmark_id'].should eq @event_bookmark1.id
    json["event_session"]['event_schedule_id'].should eq @user_schedule1.id
    json["event_session"]["show_event_notes"].should eq true
  end

  it "GET /event_sessions/:id; 'show_bookmarks' set to ON." do
    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json["event_session"]['name'].should eq @event_session1.name
    json["event_session"]['event_note_id'].should eq nil
    json["event_session"]['event_bookmark_id'].should eq @event_bookmark1.id
    json["event_session"]['event_schedule_id'].should eq @user_schedule1.id
    json["event_session"]["show_bookmarks"].should eq true
  end

  it "GET /event_sessions/:id; 'show_event_sessions' set to ON" do
    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json["event_session"]['name'].should eq @event_session1.name
    json["event_session"]['event_note_id'].should eq nil
    json["event_session"]['event_bookmark_id'].should eq @event_bookmark1.id
    json["event_session"]['event_schedule_id'].should eq @user_schedule1.id
  end

  it "GET /event_sessions/:id; get a 404 status when using invalid event session" do
    get_auth "/event_sessions/0"
    
    response.status.should eql(404)
  end

  it "GET /event_sessions/event/:event_id; get a 404 status when using invalid event" do
    get_auth "/event_sessions/0"
    
    response.status.should eql(404)
  end

  it "GET /event_sessions/:id; 'show_event_session_evaluations' not set to OFF.. Evals returned and show_eval flag = true" do
    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json.count.should eq(1)
    json["event_session"]["show_event_session_evaluations"].should eq true
    json["event_session"]["event_session_evaluations"].should_not eq []
  end

  it "GET /event_sessions/event/:event_id; 'show_event_sessions' set to ON" do
    get_auth "/event_sessions/event/#{@event.id}"
    
    response.status.should eql(200)
    json["event_sessions"].count.should eq(7)
    json["event_sessions"].first['name'].should eq @event_session1.name
    json["event_sessions"].first['event_note_id'].should eq nil
    json["event_sessions"].first['event_bookmark_id'].should eq @event_bookmark1.id
    json["event_sessions"].first['event_schedule_id'].should eq @user_schedule1.id
    json["event_sessions"].second['name'].should eq @event_session7.name
    json["event_sessions"].second['event_note_id'].should eq nil
    json["event_sessions"].second['event_bookmark_id'].should eq nil
    json["event_sessions"].second['event_schedule_id'].should eq nil
    json["event_sessions"].third['name'].should eq @event_session4.name
    json["event_sessions"].third['event_note_id'].should eq nil
    json["event_sessions"].third['event_bookmark_id'].should eq nil
    json["event_sessions"].third['event_schedule_id'].should eq @user_schedule4.id
    json["event_sessions"][4]['name'].should eq @event_session5.name
    json["event_sessions"][5]['name'].should eq @event_session6.name
    json["event_sessions"][6]['name'].should eq @event_session2.name
  end

  it "GET /event_sessions/:id; 'show_my_schedule' set to OFF at Event level." do
    create(:app_setting, app_setting_option_id: 170, event: @event)
    event_note3= create(:event_note, :random, event_session: @event_session1, creator: @user)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json["event_session"]["name"].should eq @event_session1.name
    json["event_session"]["event_note_id"].should eq event_note3.id
    json["event_session"]["event_bookmark_id"].should eq @event_bookmark1.id
    json["event_session"]["event_schedule_id"].should eq nil
    json["event_session"]["show_my_schedule"].should eq false
  end

  it "GET /event_sessions/:id; 'show_my_schedule' set to OFF at UserRole level." do
    create(:app_setting, app_setting_option_id: 171, user_role: @user.user_role)
    event_note3= create(:event_note, :random, event_session: @event_session1, creator: @user)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json["event_session"]["name"].should eq @event_session1.name
    json["event_session"]["event_note_id"].should eq event_note3.id
    json["event_session"]["event_bookmark_id"].should eq @event_bookmark1.id
    json["event_session"]["event_schedule_id"].should eq nil
    json["event_session"]["show_my_schedule"].should eq false
  end

  it "GET /event_sessions/:id; with 'show_event_notes' set to OFF at App level." do
    create(:app_setting, app_setting_option_id: 146)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json["event_session"]['name'].should eq @event_session1.name
    json["event_session"]['event_note_id'].should eq nil
    json["event_session"]['event_bookmark_id'].should eq @event_bookmark1.id
    json["event_session"]['event_schedule_id'].should eq @user_schedule1.id
    json["event_session"]["show_event_notes"].should eq false
  end

  it "GET /event_sessions/:id; with 'show_event_notes' set to OFF at Event level." do
    create(:app_setting, app_setting_option_id: 147, event: @event)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json["event_session"]['name'].should eq @event_session1.name
    json["event_session"]['event_note_id'].should eq nil
    json["event_session"]['event_bookmark_id'].should eq @event_bookmark1.id
    json["event_session"]['event_schedule_id'].should eq @user_schedule1.id
    json["event_session"]["show_event_notes"].should eq false
  end

  it "GET /event_sessions/:id; with 'show_event_notes' set to OFF at UserRole level." do
    create(:app_setting, app_setting_option_id: 148, user_role: @user.user_role)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json["event_session"]['name'].should eq @event_session1.name
    json["event_session"]['event_note_id'].should eq nil
    json["event_session"]['event_bookmark_id'].should eq @event_bookmark1.id
    json["event_session"]['event_schedule_id'].should eq @user_schedule1.id
    json["event_session"]["show_event_notes"].should eq false
  end

  it "GET /event_sessions/:id; 'show_bookmarks' set to OFF at App level." do
    create(:app_setting, app_setting_option_id: 149)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json["event_session"]['name'].should eq @event_session1.name
    json["event_session"]['event_note_id'].should eq nil
    json["event_session"]['event_bookmark_id'].should eq nil
    json["event_session"]['event_schedule_id'].should eq @user_schedule1.id
    json["event_session"]["show_bookmarks"].should eq false
  end

  it "GET /event_sessions/:id; 'show_bookmarks' set to OFF at Event level." do
    create(:app_setting, app_setting_option_id: 150, event: @event)

    get_auth "/event_sessions/#{@event_session1.id}"
    response.status.should eql(200)
    json["event_session"]['name'].should eq @event_session1.name
    json["event_session"]['event_note_id'].should eq nil
    json["event_session"]['event_bookmark_id'].should eq nil
    json["event_session"]['event_schedule_id'].should eq @user_schedule1.id
    json["event_session"]["show_bookmarks"].should eq false
  end

  it "GET /event_sessions/:id; 'show_bookmarks' set to OFF at UserRole level." do
    create(:app_setting, app_setting_option_id: 151, user_role: @user.user_role)
    
    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json["event_session"]['name'].should eq @event_session1.name
    json["event_session"]['event_note_id'].should eq nil
    json["event_session"]['event_bookmark_id'].should eq nil
    json["event_session"]['event_schedule_id'].should eq @user_schedule1.id
    json["event_session"]["show_bookmarks"].should eq false
  end

  it "GET /event_sessions/event/:event_id; 'show_event_sessions' set to OFF at App level" do
    create(:app_setting, app_setting_option_id: 125)

    get_auth "/event_sessions/event/#{@event.id}"
    response.status.should eql(403)
  end

  it "GET /event_sessions/event/:event_id; 'show_event_sessions' set to OFF at App level" do
    create(:app_setting, app_setting_option_id: 140)

    get_auth "/event_sessions/event/#{@event.id}"
    response.status.should eql(403)
  end

  it "GET /event_sessions/event/:event_id; 'show_event_sessions' set to OFF at Event level" do
    create(:app_setting, app_setting_option_id: 141, event: @event)

    get_auth "/event_sessions/event/#{@event.id}"
    
    response.status.should eql(403)
  end

  it "GET /event_sessions/event/:event_id; 'show_event_sessions' set to OFF at UserRole level" do
    create(:app_setting, app_setting_option_id: 142, user_role: @user.user_role)

    get_auth "/event_sessions/event/#{@event.id}"
    
    response.status.should eql(403)
  end

  it "GET /event_sessions/event/:event_id; 'show_event_sessions' set to OFF at UserRole level" do
    create(:app_setting, app_setting_option_id: 126, user_role: @user.user_role)

    get_auth "/event_sessions/event/#{@event.id}"
    
    response.status.should eql(403)
  end

  it "GET /event_sessions/:id; 'show_event_sessions' set to OFF at App level" do
    create(:app_setting, app_setting_option_id: 125)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(403)
  end

  it "GET /event_sessions/:id; 'show_event_sessions' set to OFF at App level" do
    create(:app_setting, app_setting_option_id: 140)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(403)
  end

  it "GET /event_sessions/:id; 'show_event_sessions' set to OFF at Event level" do
    create(:app_setting, app_setting_option_id: 141, event: @event)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(403)
  end

  it "GET /event_sessions/:id; 'show_event_sessions' set to OFF at UserRole level" do
    create(:app_setting, app_setting_option_id: 142, user_role: @user.user_role)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(403)
  end

  it "GET /event_sessions/:id; 'show_event_sessions' set to OFF at UserRole level" do
    create(:app_setting, app_setting_option_id: 126, user_role: @user.user_role)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(403)
  end

  it "GET /event_sessions/:id; 'show_event_session_evaluations' set to OFF at App level. Evals not returned and show_eval flag = false" do
    create(:app_setting, app_setting_option_id: 154)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json.count.should eq(1)
    json["event_session"]["event_session_evaluations"].should eq []
    json["event_session"]["show_event_session_evaluations"].should eq false
  end

  it "GET /event_sessions/:id; 'show_event_session_evaluations' set to OFF at UserRole level. Evals not returned and show_eval flag = false" do
    create(:app_setting, app_setting_option_id: 156, user_role: @user.user_role)

    get_auth "/event_sessions/#{@event_session1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event_session"]["event_session_evaluations"].should eq []
    json["event_session"]["show_event_session_evaluations"].should eq false
  end

  it "GET /event_sessions/:id; 'show_event_session_evaluations' set to OFF at Event level. Evals not returned and show_eval flag = false" do
    create(:app_setting, app_setting_option_id: 155, event: @event)

    get_auth "/event_sessions/#{@event_session1.id}"
    
    response.status.should eql(200)
    json.count.should eq(1)
    json["event_session"]["show_event_session_evaluations"].should eq false
    json["event_session"]["event_session_evaluations"].should eq []
  end

end