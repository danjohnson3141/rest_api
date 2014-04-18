require "./db/seed_data"

data = []
Event.all.each do |event|
  data += [ { user: SeedData.get_random(User), event: event },
           { user: SeedData.get_random(User), event: event } ]
end

SeedData.new('EventStaffUser').load(data)
