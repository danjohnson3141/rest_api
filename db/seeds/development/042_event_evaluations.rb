require "./db/seed_data"

data = []
Event.all.each do |event|
data += [ { event: event, name: "Take survey for #{event.name}", survey_link: "https://www.surveygizmo.com/event#{event.id}", user_role_id: 1 } ]
data += [ { event: event, name: "Take survey for #{event.name}", survey_link: "https://www.surveygizmo.com/sponsor/event#{event.id}", user_role_id: 4 } ]
end

SeedData.new('EventEvaluation').load(data)
