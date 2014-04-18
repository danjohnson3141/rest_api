require 'spec_helper'

describe 'EventBookmarks' do

  before(:all) do
    @user = create(:user)
    @user1 = create(:user, :random)
    @user2 = create(:user, :random)

    @event1 = create(:event, :random)
    @event2 = create(:event, :random)

    @event_session1 = create(:event_session, :random, event: @event1)
    @event_session2 = create(:event_session, :random, event: @event2)

    @event_speaker1 = create(:event_speaker, :random, event_session: @event_session1)
    @event_speaker2 = create(:event_speaker, :random, event_session: @event_session2)

    @event_user1 = create(:event_user, :registered, event: @event1, user: @user)
    @event_user2 = create(:event_user, :registered, event: @event2, user: @user)

    @sponsor1 = create(:sponsor, event: @event1)
    @sponsor2 = create(:sponsor, event: @event2)

    @bookmark_user1 = create(:event_bookmark, event_user: @event_user1, creator: @user)
    @bookmark_user2 = create(:event_bookmark, event_speaker: @event_speaker1, creator: @user)
    @bookmark_user3 = create(:event_bookmark, event_session: @event_session1, creator: @user)
    @bookmark_user4 = create(:event_bookmark, sponsor: @sponsor1, creator: @user)
    @bookmark_user5 = create(:event_bookmark, event_user: @event_user2, creator: @user)
  end

  it "GET /event_bookmarks/event/:event_id; gets an event_user bookmark for one event" do
    event_user3 = create(:event_user, :registered, event: @event2, user: @user1)
    note1 = create(:event_note, :random, event_session: @event_session1)

    get_auth "/event_bookmarks/event/#{@event1.id}"

    response.status.should eql(200)
    json["event_bookmarks"].count.should eq(4)
    json["event_bookmarks"].first["id"].should eq @bookmark_user1.id
    json["event_bookmarks"].first["event"]["id"].should eq @event1.id
    json["event_bookmarks"].first["event_user"]["id"].should eq @event_user1.id
    json["event_bookmarks"].first["event_session"].should eq nil
    json["event_bookmarks"].first["event_speaker"].should eq nil
    json["event_bookmarks"].first["sponsor"].should eq nil
    json["event_bookmarks"].first["event_user"]["user"]["id"].should eq @user.id
  end

  it "GET /event_bookmarks; receives all the event_bookmarks for the active user" do
    get_auth "/event_bookmarks"

    response.status.should eql(200)
    json["event_bookmarks"].count.should eq(5)
    json["event_bookmarks"].first["id"].should eq @bookmark_user1.id
    json["event_bookmarks"].first["event"]["id"].should eq @event1.id
    json["event_bookmarks"].first["event_user"]["id"].should eq @event_user1.id
    json["event_bookmarks"].first["event_session"].should eq nil
    json["event_bookmarks"].first["event_speaker"].should eq nil
    json["event_bookmarks"].first["sponsor"].should eq nil
    json["event_bookmarks"].first["event_user"]["user"]["id"].should eq @user.id
  end

  it "GET /event_bookmarks/:id; gets a specific event bookmark" do
    get_auth "/event_bookmarks/#{@bookmark_user2.id}"

    response.status.should eql(200)
    json["event_bookmark"]["id"].should eq @bookmark_user2.id
    json["event_bookmark"]["event"]["id"].should eq @event1.id
    json["event_bookmark"]["event_session"].should eq nil
    json["event_bookmark"]["event_speaker"]["id"].should eq @event_speaker1.id
    json["event_bookmark"]["sponsor"].should eq nil
    json["event_bookmark"]["event_user"].should eq nil
  end

  it "POST /event_bookmarks; create session event bookmark, has permission" do
    post_auth "/event_bookmarks", { event_bookmark: { event_session_id: @event_session1.id } }

    response.status.should eql(201)
    json["event_bookmark"]["event"]["id"].should eq @event1.id
    json["event_bookmark"]["event_session"]["id"].should eq @event_session1.id
  end

  it "POST /event_bookmarks; create speaker event bookmark, has permission" do
    event_speaker = create(:event_speaker, :random, event_session: @event_session1)

    post_auth '/event_bookmarks', { event_bookmark: { body: 'Notes', event_speaker_id: @event_speaker1.id } }

    response.status.should eql(201)
    json["event_bookmark"]["event"]["id"].should eq @event1.id
    json["event_bookmark"]["event_speaker"]["id"].should eq @event_speaker1.id
  end

  it "DELETE /event_bookmarks/:id; delete an existing event bookmark" do
    bookmark_user = create(:event_bookmark, event_user: @event_user1, creator: @user)

    delete_auth "/event_bookmarks/#{bookmark_user.id}"

    response.status.should eql(204)
  end

  it "GET /event_bookmarks/event/:event_id; gets 404 when event does not exist" do
    get_auth "/event_bookmarks/event/0"
   
    response.status.should eql(404)
  end

  it "POST /event_bookmarks; create speaker event bookmark, has permission, fails due to multiple subjects" do
    event_speaker = create(:event_speaker, :random, event_session: @event_session1)

    post_auth '/event_bookmarks', { event_bookmark: { body: 'Notes', event_speaker_id: event_speaker.id, event_session_id: @event_session1.id } }
    
    response.status.should eql(422)
    json["event_bookmarks"].should eq ["Please provide only one of the following: event_user_id, sponsor_id, event_speaker_id, or event_session_id."]
  end

  it "POST /event_bookmarks; create speaker event bookmark, has permission, fails due to multiple subjects" do
    post_auth '/event_bookmarks', { event_bookmark: { body: 'Notes', event_speaker_id: @event_speaker1.id, event_session_id: @event_session1.id, event_user: @event_user1.id } }
    
    response.status.should eql(422)
    json["event_bookmarks"].should eq ["Please provide only one of the following: event_user_id, sponsor_id, event_speaker_id, or event_session_id."]
  end

  it "POST /event_bookmarks; create speaker event bookmark, has permission, fails due to lack of subject (i.e. event_session_id, event_speaker_id, etc." do
    post_auth '/event_bookmarks', { event_bookmark: { body: 'Notes' } }
    
    response.status.should eql(422)
  end

  it "DELETE /event_bookmarks/:id; attempts to delete a note record for another user" do
    bookmark_user = create(:event_bookmark, event_user: @event_user1, creator: @user1)

    delete_auth "/event_bookmarks/#{bookmark_user.id}"
    
    response.status.should eql(403)
  end

  it "DELETE /event_bookmarks/:id; delete a note that does not exist" do
    delete_auth "/event_bookmarks/0"
    
    response.status.should eql(404)
  end

  it "GET /event_bookmarks/event/:event_id; gets permission denied when notes are turned off" do
    bookmark_user1 = create(:event_bookmark, event_user: @event_user1, creator: @user)
    create(:app_setting, app_setting_option_id: 126, user_role: @user.user_role)

    get_auth "/event_bookmarks/event/#{@event1.id}"
    
    response.status.should eql(403)
  end

  it "POST /event_bookmarks; create event bookmark, 'event_bookmarks' set to OFF at App level" do
    create(:app_setting, app_setting_option_id: 125)

    post_auth '/event_bookmarks', { event_bookmark: { body: 'Notes', event_session_id: @event_session1.id } }
    
    response.status.should eql(403)
  end

  it "POST /event_bookmarks; create event bookmark, 'event_bookmarks' set to OFF at App level" do
    create(:app_setting, app_setting_option_id: 149)

    post_auth '/event_bookmarks', { event_bookmark: { body: 'Notes', event_session_id: @event_session1.id } }
    
    response.status.should eql(403)
  end

  it "POST /event_bookmarks; create event bookmark, 'event_bookmarks' set to OFF at Event level" do
    create(:app_setting, app_setting_option_id: 150, event: @event1)

    post_auth '/event_bookmarks', { event_bookmark: { body: 'Notes', event_session_id: @event_session1.id } }
    
    response.status.should eql(403)
  end

  it "POST /event_bookmarks; create event bookmark, 'event_bookmarks' set to OFF at UserRole level" do
    create(:app_setting, app_setting_option_id: 151, user_role: @user.user_role)

    post_auth '/event_bookmarks', { event_bookmark: { body: 'Notes', event_session_id: @event_session1.id } }
    
    response.status.should eql(403)
  end

  it "POST /event_bookmarks; create event bookmark, 'event_bookmarks' set to OFF at UserRole level" do
    create(:app_setting, app_setting_option_id: 126, user_role: @user.user_role)

    post_auth '/event_bookmarks', { event_bookmark: { body: 'Notes', event_session_id: @event_session1.id } }
    
    response.status.should eql(403)
  end

end