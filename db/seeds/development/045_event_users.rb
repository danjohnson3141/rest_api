require "./db/seed_data"

data = []
Event.all.each do |event|
  User.where(organization_name: "Evanta").each do |user|
    data += [ { user: user, event: event, event_registration_status: SeedData.get_random(EventRegistrationStatus) } ]
  end
end

SeedData.new('EventUser').load(data)