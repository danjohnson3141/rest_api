require "./db/seed_data"

data = []
EventSession.all.each do |event_session|
data += [ { event_session: event_session, name: "Take survey for #{event_session.name}", survey_link: "https://www.surveygizmo.com/event#{event_session.event.id}/session/#{event_session.id}" } ]
end

SeedData.new('EventSessionEvaluation').load(data)
