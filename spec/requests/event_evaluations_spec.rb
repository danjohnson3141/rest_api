require 'spec_helper'

describe 'EventEvaluations' do

  before(:all) do
    @user = create(:user)
    @event1 = create(:event, :random, :today, :open)
    @event_user = create(:event_user, :attended, user: @user, event: @event1)
    @event_eval1 = create(:event_evaluation, name: "Member Eval 1", event: @event1, survey_link: "http://www.surveygizmo.com/event/#{@event1.id}/member_survey_1", display_rank: 3, created_at: Time.now - 12.hours)
    @event_eval2 = create(:event_evaluation, :sponsor, name: "Sponsor Eval 1", event: @event1, survey_link: "http://www.surveygizmo.com/event/#{@event1.id}/sponsor_survey_1", display_rank: 3, created_at: Time.now - 48.hours)
  end  

  it "GET /event_evaluations/:id; return specific evals record" do
    get_auth "/event_evaluations/#{@event_eval1.id}"

    response.status.should eql(200)
    json.count.should eq(1)
    json["event_evaluation"]["id"].should eq @event_eval1.id
    json["event_evaluation"]["survey_link"].should eq @event_eval1.survey_link
  end

  it "GET /event_evaluations/:id; returns 404 because user is trying to get eval that's not for their user role" do
    get_auth "/event_evaluations/#{@event_eval2.id}"
    
    response.status.should eql(403)
  end

  it "GET /event_evaluations/:id; return specific evals record, app setting is OFF, eval not returned (157)" do
    create(:app_setting, app_setting_option_id: 157, user_role: @user.user_role)

    get_auth "/event_evaluations/#{@event_eval1.id}"

    response.status.should eql(403)
  end  

  xit "GET /event_evaluations/:id; return specific evals record, app setting is OFF, eval not returned (152)" do
    create(:app_setting, app_setting_option_id: 152)

    get_auth "/event_evaluations/#{@event_eval1.id}"

    response.status.should eql(403)
  end

end