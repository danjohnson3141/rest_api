require "./db/seed_data"

data = []
20.times do
  data += [ 
    { body: Faker::Lorem.paragraph(2) + "\n\n" + Faker::Lorem.paragraph(3), 
      event_user_id: SeedData.get_random(EventUser).user_id,
      created_by: SeedData.get_random(User).id
    }
  ]  
  data += [
    { body: Faker::Lorem.paragraph(2) + "\n\n" + Faker::Lorem.paragraph(3), 
      event_speaker_id: SeedData.get_random(EventSpeaker).id,
      created_by: SeedData.get_random(User).id
    }
  ]
  data += [
    { body: Faker::Lorem.paragraph(2) + "\n\n" + Faker::Lorem.paragraph(3), 
      event_session_id: SeedData.get_random(EventSession).id,
      created_by: SeedData.get_random(User).id
    }
  ]
  data += [
    { body: Faker::Lorem.paragraph(2) + "\n\n" + Faker::Lorem.paragraph(3), 
      sponsor_id: SeedData.get_random(Sponsor).id,
      created_by: SeedData.get_random(User).id
    }
  ]
end

SeedData.new('EventNote').load(data)

data = []
10.times do
  data += [ { event_user_id: SeedData.get_random(EventUser).user_id, created_by: SeedData.get_random(User).id } ]  
  data += [ { event_speaker_id: SeedData.get_random(EventSpeaker).id, created_by: SeedData.get_random(User).id } ]
  data += [ { event_session_id: SeedData.get_random(EventSession).id, created_by: SeedData.get_random(User).id } ]
  data += [ { sponsor_id: SeedData.get_random(Sponsor).id, created_by: SeedData.get_random(User).id} ]
end

SeedData.new('EventBookmark').load(data)