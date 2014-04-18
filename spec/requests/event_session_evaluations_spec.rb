require 'spec_helper'

describe 'EventSessionEvaluations' do

  before(:all) do
    @user = create(:user)
    @group = create(:group, :open)

    @event = create(:event, :random, :today, group: @group )
    @event_session = create(:event_session, :random, is_comments_on: 1, event: @event, breakout_group: create(:group, :random, :open))
    @event_user = create(:event_user, user: @user, event: @event)
    @event_session_eval1 = create(:event_session_evaluation, event_session: @event_session, name: "Survey for event: #{@event.name}", survey_link: "http://www.surveygizmo.com/event/#{@event.id}/survey_1", display_rank: 2, created_at: Time.now - 12.hours)
  end

  it "GET /event_session_evaluations/:id; return specific evals record" do
    get_auth "/event_session_evaluations/#{@event_session_eval1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event_session_evaluation"]["id"].should eq @event_session_eval1.id
    json["event_session_evaluation"]["survey_link"].should eq @event_session_eval1.survey_link
    json["event_session_evaluation"]["event"]["id"].should eq @event.id
    json["event_session_evaluation"]["event_session"]["id"].should eq @event_session.id

  end

  it "GET /event_session_evaluations/:id; return specific evals record, app setting is OFF, eval not returned" do
    create(:app_setting, app_setting_option_id: 157, user_role: @user.user_role)

    get_auth "/event_session_evaluations/#{@event_session_eval1.id}"

    response.status.should eql(403)
  end  

  it "GET /event_session_evaluations/:id; return specific evals record, app setting is OFF, eval not returned (154)" do
    create(:app_setting, app_setting_option_id: 154)

    get_auth "/event_session_evaluations/#{@event_session_eval1.id}"

    response.status.should eql(403)
  end

end
