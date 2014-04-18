require 'spec_helper'

describe 'EventSpeakers' do

  before(:all) do
    @user = create(:user)
    @user1 = create(:user, :random)
    @user2 = create(:user, :random)
    @user3 = create(:user, :random)

    @group_open = create(:group, :random, :open)
    @group_private = create(:group, :random, :private)
    @group_secret = create(:group, :random, :secret)

    @event_open = create(:event, :random, group: @group_open)
    @event_private = create(:event, :random, group: @group_private)
    @event_secret = create(:event, :random, group: @group_secret)

    @event_session1 = create(:event_session, :random, event: @event_open, name: 'AAA', start_date_time: Time.now + 24.hours, display_rank: 1)
    @event_session2 = create(:event_session, :random, event: @event_open, name: 'BBB', start_date_time: Time.now + 48.hours, display_rank: 1)
    @event_session3 = create(:event_session, :random, event: @event_open, name: 'CCC', start_date_time: Time.now + 12.hours, display_rank: 1)

    @event_speaker1 = create(:event_speaker, :random, event_session: @event_session1, first_name: @user1.first_name, last_name: @user1.last_name, user: @user1)
    @event_speaker2 = create(:event_speaker, :random, event_session: @event_session2, first_name: @user1.first_name, last_name: @user1.last_name, user: @user1)
    @event_speaker3 = create(:event_speaker, :random, event_session: @event_session3, first_name: @user1.first_name, last_name: @user1.last_name, user: @user1)
    @event_speaker4 = create(:event_speaker, :random, event_session: @event_session1, first_name: @user2.first_name, last_name: @user2.last_name, user: @user2)

    @event_note1 = create(:event_note, :random, event_speaker: @event_speaker1, creator: @user)
    @event_note2 = create(:event_note, :random, event_speaker: @event_speaker3, creator: @user)

    @event_bookmark1 = create(:event_bookmark, event_speaker: @event_speaker2, creator: @user)
    @event_bookmark2 = create(:event_bookmark, event_speaker: @event_speaker3, creator: @user)
  end

  it "GET /event_speakers/:id; returns event_speaker record, also returns event_sessions (as elements) associated with the event that is associated with event_speaker record." do
    event_session4 = create(:event_session, :random, event: @event_private, name: "Should not display")
    event_speaker5 = create(:event_speaker, :random, event_session: event_session4, first_name: @user1.first_name, last_name: @user1.last_name, user: @user1)
    event_user = create(:event_user, event: @event_open, user: @user)

    get_auth "/event_speakers/#{@event_speaker1.id}"

    response.status.should eql(200)
    json["event_speaker"]['id'].should eq @event_speaker1.id
    json["event_speaker"]["event_sessions"].first["name"].should eq @event_session3.name
    json["event_speaker"]["event_sessions"].second["name"].should eq @event_session1.name
    json["event_speaker"]["event_sessions"].third["name"].should eq @event_session2.name
    json["event_speaker"]['event_sessions'].to_s.should_not include event_session4.name
    json["event_speaker"]['first_name'].should eq @event_speaker1.first_name
  end

  it "GET /event_speakers/:id; get 1 event_speaker record, this is all that will be returned" do
    get_auth "/event_speakers/#{@event_speaker1.id}"
    
    response.status.should eql(200)
    json["event_speaker"]['first_name'].should eq @event_speaker1.first_name
    json["event_speaker"]['event_note_id'].should eq @event_note1.id
    json["event_speaker"]['event_bookmark_id'].should eq nil
  end

  it "GET /event_speakers/event/:event_id; get all event_speakers for specific event (3 in this case)" do
    get_auth "/event_speakers/event/#{@event_open.id}"
    
    response.status.should eql(200)
    json["event_speakers"].count.should eq(4)
    json["event_speakers"][0]['id'].should eq @event_speaker3.id
    json["event_speakers"][0]['event_note_id'].should eq @event_note2.id
    json["event_speakers"][0]['event_bookmark_id'].should eq @event_bookmark2.id
    json["event_speakers"][1]['id'].should eq @event_speaker1.id
    json["event_speakers"][1]['event_note_id'].should eq @event_note1.id
    json["event_speakers"][1]['event_bookmark_id'].should eq nil
    json["event_speakers"][3]['id'].should eq @event_speaker2.id
    json["event_speakers"][3]['event_note_id'].should eq nil
    json["event_speakers"][3]['event_bookmark_id'].should eq @event_bookmark1.id
  end

  it "GET /event_speakers/event_session/:event_session_id; get all event_speakers for specific event session (2 in this case)" do
    event_bookmark4 = create(:event_bookmark, event_speaker: @event_speaker4, creator: @user)

    get_auth "/event_speakers/event_session/#{@event_session1.id}"
    
    response.status.should eql(200)
    json["event_speakers"].count.should eq(2)
    json["event_speakers"].first['id'].should eq @event_speaker1.id
    json["event_speakers"].first['event_note_id'].should eq @event_note1.id
    json["event_speakers"].first['event_bookmark_id'].should eq nil
    json["event_speakers"].second['id'].should eq @event_speaker4.id
    json["event_speakers"].second['event_note_id'].should eq nil
    json["event_speakers"].second['event_bookmark_id'].should eq event_bookmark4.id
  end

  it "GET /event_speakers/:id; get a 404 status when using invalid speaker" do
    get_auth "/event_speakers/0"

    response.status.should eql(404)
  end

  it "GET /event_speakers/:id; event is private, user is not member, not user, should 403" do
    event_session5 = create(:event_session, :random, event: @event_private, name: 'Private')
    event_speaker5 = create(:event_speaker, :random, event_session: event_session5, first_name: @user2.first_name, last_name: @user2.last_name, user: @user2)

    get_auth "/event_speakers/#{event_speaker5.id}"

    response.status.should eql(403)
  end  

  it "GET /event_speakers/:id; event is private, user is member, not user, should work" do
    group_member2 = create(:group_member, group: @group_private, user: @user)
    event_session5 = create(:event_session, :random, event: @event_private, name: 'Private')
    event_speaker5 = create(:event_speaker, :random, event_session: event_session5, first_name: @user2.first_name, last_name: @user2.last_name, user: @user2)

    get_auth "/event_speakers/#{event_speaker5.id}"

    response.status.should eql(200)
  end   

  it "GET /event_speakers/:id; event is secret, user is not member, not user, should 404" do
    event_session5 = create(:event_session, :random, event: @event_secret, name: 'Secret')
    event_speaker5 = create(:event_speaker, :random, event_session: event_session5, first_name: @user2.first_name, last_name: @user2.last_name, user: @user2)

    get_auth "/event_speakers/#{event_speaker5.id}"

    response.status.should eql(404)
  end  

  it "GET /event_speakers/:id; event is secret, user is member, not user, should work" do
    member = create(:group_member, group: @group_secret, user: @user)
    event_session5 = create(:event_session, :random, event: @event_secret, name: 'Secret')
    event_speaker5 = create(:event_speaker, :random, event_session: event_session5, first_name: @user2.first_name, last_name: @user2.last_name, user: @user2)

    get_auth "/event_speakers/#{event_speaker5.id}"

    response.status.should eql(200)
  end  

  it "GET /event_speakers/:id; event is secret, not member, is user, should work" do
    member = create(:group_member, group: @group_secret, user: @user)
    event_session5 = create(:event_session, :random, event: @event_secret, name: 'Secret')
    event_speaker5 = create(:event_speaker, :random, event_session: event_session5, first_name: @user2.first_name, last_name: @user2.last_name, user: @user2)

    get_auth "/event_speakers/#{event_speaker5.id}"

    response.status.should eql(200)
  end  
    
end