require "./db/seed_data"

def thumbnail
  x = [200,250,300,320,420,480,500].sample
  y = [200,250,300,320,420,480,500].sample
  "http://placekitten.com/#{x}/#{y}"
end

data = []

# Group Article
5.times do
  group_member = SeedData.get_random(GroupMember)
  body = Faker::Lorem.paragraph(2) + "\n\n" + Faker::Lorem.paragraph(3)
  data += [
    { title: Faker::Company.catch_phrase + ': ' + Faker::Commerce.product_name,
      body: body,
      excerpt: body[0,200],
      thumbnail_teaser_photo: thumbnail,
      display_rank: rand(10),
      view_count: rand(50),
      group_id: group_member.group_id,
      created_by: group_member.user_id
    }
  ]
end
# Group Post
20.times do
  group_member = SeedData.get_random(GroupMember)
  body = Faker::Lorem.paragraph(2) + "\n\n" + Faker::Lorem.paragraph(3)
  data += [
    { body: body,
      thumbnail_teaser_photo: thumbnail,
      display_rank: rand(10),
      view_count: rand(50),
      group_id: group_member.group_id,
      created_by: group_member.user_id
    }
  ]
end

# Event Article
5.times do
  event_user = SeedData.get_random(EventUser)
  body = Faker::Lorem.paragraph(2) + "\n\n" + Faker::Lorem.paragraph(3)
  data += [
    { title: Faker::Company.catch_phrase + ': ' + Faker::Commerce.product_name,
      body: body,
      excerpt: body[0,200],
      thumbnail_teaser_photo: thumbnail,
      display_rank: rand(10),
      view_count: rand(50),
      event: event_user.event,
      created_by: event_user.user_id
    }
  ]
end

# Event Post
20.times do
  event_user = SeedData.get_random(EventUser)
  body = Faker::Lorem.paragraph(2) + "\n\n" + Faker::Lorem.paragraph(3)
  data += [
    { body: body,
      thumbnail_teaser_photo: thumbnail,
      display_rank: rand(10),
      view_count: rand(50),
      event: event_user.event,
      created_by: event_user.user_id
    }
  ]
end

# Event Session Post
20.times do
  event_session = SeedData.get_random(EventSession)
  body = Faker::Lorem.paragraph(2) + "\n\n" + Faker::Lorem.paragraph(3)
  data += [
    { title: Faker::Company.catch_phrase + ': ' + Faker::Commerce.product_name,
      body: body,
      excerpt: body[0,200],
      thumbnail_teaser_photo: thumbnail,
      display_rank: rand(10),
      view_count: rand(50),
      event_session: event_session,
      creator: event_session.event.event_users.sample.user
    }
  ]
end

# Sponsored posts

10.times do
  user = SeedData.get_random(User)
  event_user = SeedData.get_random(EventUser)
  body = Faker::Lorem.paragraph(2) + "\n\n" + Faker::Lorem.paragraph(3)
  data += [
    { body: body,
      thumbnail_teaser_photo: thumbnail,
      display_rank: rand(10),
      view_count: rand(50),
      sponsor_id: SeedData.get_random(Sponsor).id,
      event: event_user.event,
      created_by: event_user.user_id
    }
  ]
end
10.times do
  user = SeedData.get_random(User)
  group_member = SeedData.get_random(GroupMember)
  body = Faker::Lorem.paragraph(2) + "\n\n" + Faker::Lorem.paragraph(3)
  data += [
    { body: body,
      thumbnail_teaser_photo: thumbnail,
      display_rank: rand(10),
      view_count: rand(50),
      sponsor_id: SeedData.get_random(Sponsor).id,
      group_id: group_member.group_id,
      created_by: group_member.user_id
    }
  ]
end
10.times do
  event_session = SeedData.get_random(EventSession)
  body = Faker::Lorem.paragraph(2) + "\n\n" + Faker::Lorem.paragraph(3)
  data += [
    { body: body,
      thumbnail_teaser_photo: thumbnail,
      display_rank: rand(10),
      view_count: rand(50),
      sponsor_id: SeedData.get_random(Sponsor).id,
      event_session: event_session,
      creator: event_session.event.event_users.sample.user
    }
  ]
end

SeedData.new('Post').load(data)
