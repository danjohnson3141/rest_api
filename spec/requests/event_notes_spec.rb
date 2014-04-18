require 'spec_helper'

describe 'EventNotes' do

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

    @event_user1 = create(:event_user, :registered, event: @event1, user: @user2)
    @event_user2 = create(:event_user, :registered, event: @event2, user: @user2)

    @event_sponsor1 = create(:sponsor, event: @event1)
    @event_sponsor2 = create(:sponsor, event: @event2)

    @event_note1 = create(:event_note, :random, creator: @user,  created_at: Time.now - 0.minute, event_session: @event_session1)
    @event_note2 = create(:event_note, :random, creator: @user1, created_at: Time.now - 4.minute, event_session: @event_session2)
    @event_note3 = create(:event_note, :random, creator: @user,  created_at: Time.now - 5.minute, event_speaker: @event_speaker1)
    @event_note4 = create(:event_note, :random, creator: @user,  created_at: Time.now - 2.minute, event_speaker: @event_speaker2)
    @event_note5 = create(:event_note, :random, creator: @user,  created_at: Time.now - 1.minute, event_user: @event_user1)
    @event_note6 = create(:event_note, :random, creator: @user,  created_at: Time.now - 6.minute, event_user: @event_user2)
    @event_note7 = create(:event_note, :random, creator: @user,  created_at: Time.now - 7.minute, sponsor: @event_sponsor1)
    @event_note8 = create(:event_note, :random, creator: @user,  created_at: Time.now - 3.minute, sponsor: @event_sponsor2)
  end

  it "GET /event_notes/event/:event_id; returns four event notes for event, should be sorted chrono descending" do
    get_auth "/event_notes/event/#{@event1.id}"

    response.status.should eql(200)
  
    json["event_notes"].count.should eq 4
    json["event_notes"][0]["id"].should eq @event_note1.id
    json["event_notes"][1]["id"].should eq @event_note5.id
    json["event_notes"][2]["id"].should eq @event_note3.id
    json["event_notes"][3]["id"].should eq @event_note7.id
    
    json["event_notes"][0]["event"]["id"].should eq @event1.id

    json["event_notes"][0]["event_user"].should eq nil 
    json["event_notes"][0]["event_speaker"].should eq nil
    json["event_notes"][0]["event_session"]["id"].should eq @event_session1.id
    json["event_notes"][0]["event_sponsor"].should eq nil    

    json["event_notes"][1]["event_user"]["id"].should eq @event_user1.id
    json["event_notes"][1]["event_speaker"].should eq nil
    json["event_notes"][1]["event_session"].should eq nil
    json["event_notes"][1]["event_sponsor"].should eq nil    

    json["event_notes"][2]["event_user"].should eq nil
    json["event_notes"][2]["event_speaker"]["id"].should eq @event_speaker1.id
    json["event_notes"][2]["event_session"].should eq nil
    json["event_notes"][2]["event_sponsor"].should eq nil    

    json["event_notes"][3]["event_user"].should eq nil 
    json["event_notes"][3]["event_speaker"].should eq nil
    json["event_notes"][3]["event_session"].should eq nil
    json["event_notes"][3]["sponsor"]["id"].should eq @event_sponsor1.id
  end

  it "PATCH /event_notes/:id;" do
    patch_auth "/event_notes/#{@event_note1.id}", { event_note: { body: 'Update' } }

    response.status.should eql(204)
  end

  it "PUT /event_notes/:id;" do
    put_auth "/event_notes/#{@event_note1.id}", { event_note: { body: 'Update' } }

    response.status.should eql(204)
  end

  it "PATCH /event_notes/:id; can't update notes other than your own" do
    patch_auth "/event_notes/#{@event_note2.id}", { event_note: { body: 'Update' } }

    response.status.should eql(403)
  end

  it "POST /event_notes; create session event note, has permission" do
    post_auth "/event_notes", { event_note: { body: 'Notes', event_session_id: @event_session1.id } }

    response.status.should eql(201)

    json["event_note"]["event"]["id"].should eq @event1.id
    json["event_note"]["event_session"]["id"].should eq @event_session1.id
  end

  it "POST /event_notes; create sponsor event note, has permission" do
    post_auth "/event_notes", { event_note: { body: 'Notes', sponsor_id: @event_sponsor1.id } }
    
    response.status.should eql(201)
    json["event_note"]["event"]["id"].should eq @event1.id
    json["event_note"]["sponsor"]["id"].should eq @event_sponsor1.id
  end

  it "POST /event_notes; create speaker event note, has permission" do
    post_auth '/event_notes', { event_note: { body: 'Notes', event_speaker_id: @event_speaker1.id } }

    response.status.should eql(201)
    json["event_note"]["event"]["id"].should eq @event1.id
    json["event_note"]["event_speaker"]["id"].should eq @event_speaker1.id
  end

  it "POST /event_notes; create speaker event note, has permission, fails due to multiple subjects" do
    post_auth '/event_notes', { event_note: { body: 'Notes', event_speaker_id: @event_speaker1.id, event_session_id: @event_session1.id } }

    response.status.should eql(422)
    json["event_notes"].should eq ["Please provide only one of the following: event_user_id, sponsor_id, event_speaker_id, or event_session_id."]
  end

  it "POST /event_notes; create speaker event note, has permission, fails due to multiple subjects" do
    post_auth '/event_notes', { event_note: { body: 'Notes', event_speaker_id: @event_speaker1.id, event_session_id: @event_session1.id, event_user: @event_user1.id } }

    response.status.should eql(422)
    json["event_notes"].should eq ["Please provide only one of the following: event_user_id, sponsor_id, event_speaker_id, or event_session_id."]
  end

  it "POST /event_notes; create speaker event note, has permission, fails due to lack of subject (i.e. event_session_id, event_speaker_id, etc." do
    post_auth '/event_notes', { event_note: { body: 'Notes' } }

    response.status.should eql(422)
  end

  it "DELETE /event_notes/:id; delete an existing event note" do
    delete_auth "/event_notes/#{@event_note1.id}"

    response.status.should eql(204)
  end

  it "DELETE /event_notes/:id; attempts to delete a note record for another user" do
    delete_auth "/event_notes/#{@event_note2.id}"

    response.status.should eql(403)
  end

  it "DELETE /event_notes/:id; delete a note that does not exist" do
    delete_auth "/event_notes/0"

    response.status.should eql(404)
  end

  it "GET /event_notes/event/:event_id; gets 404 when event does not exist" do
    get_auth "/event_notes/event/0"

    response.status.should eql(404)
  end

  it "POST /event_notes; create event note, 'event_notes' set to OFF at App level" do
    create(:app_setting, app_setting_option_id: 125)

    post_auth '/event_notes', { event_note: { body: 'Notes', event_session_id: @event_session1.id } }

    response.status.should eql(403)
  end

  it "POST /event_notes; create event note, 'event_notes' set to OFF at App level" do
    create(:app_setting, app_setting_option_id: 146)

    post_auth '/event_notes', { event_note: { body: 'Notes', event_session_id: @event_session1.id } }
    response.status.should eql(403)
  end

  it "POST /event_notes; create event note, 'event_notes' set to OFF at Event level" do
    create(:app_setting, app_setting_option_id: 147, event: @event1)

    post_auth '/event_notes', { event_note: { body: 'Notes', event_session_id: @event_session1.id } }
    response.status.should eql(403)
  end

  it "POST /event_notes; create event note, 'event_notes' set to OFF at UserRole level" do
    create(:app_setting, app_setting_option_id: 148, user_role: @user.user_role)

    post_auth '/event_notes', { event_note: { body: 'Notes', event_session_id: @event_session1.id } }
    response.status.should eql(403)
  end

  it "POST /event_notes; create event note, 'event_notes' set to OFF at UserRole level" do
    create(:app_setting, app_setting_option_id: 126, user_role: @user.user_role)

    post_auth '/event_notes', { event_note: { body: 'Notes', event_session_id: @event_session1.id } }
    response.status.should eql(403)
  end

  it "GET /event_notes/event/:event_id; gets permission denied when notes are turned off" do
    create(:app_setting, app_setting_option_id: 126, user_role: @user.user_role)

    get_auth "/event_notes/event/#{@event1.id}"

    response.status.should eql(403)
  end

end