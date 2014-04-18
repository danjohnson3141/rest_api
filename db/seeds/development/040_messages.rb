require "./db/seed_data"

data = [
  {
    body: Faker::Lorem.sentence,
    sender_user_id: 12,
    recipient_user_id: 2,
    created_at: rand(10.days).ago
  },
  {
    body: Faker::Lorem.sentence,
    sender_user_id: 13,
    recipient_user_id: 2,
    viewed_date: "2014-01-20 13:22:11",
    created_at: rand(10.days).ago
  },
  {
    body: Faker::Lorem.sentence,
    sender_user_id: 14,
    recipient_user_id: 2,
    viewed_date: "2014-01-21 14:32:11",
    created_at: rand(10.days).ago
  },
  {
    body: Faker::Lorem.sentence,
    sender_user_id: 15,
    recipient_user_id: 2,
    created_at: rand(10.days).ago
  },
  {
    body: Faker::Lorem.sentence,
    sender_user_id: 15,
    recipient_user_id: 2,
    viewed_date: "2014-01-22 15:16:56",
    created_at: rand(10.days).ago
  },
  {
    body: Faker::Lorem.sentence,
    sender_user_id: 2,
    recipient_user_id: 15,
    viewed_date: "2014-01-23 17:12:09",
    created_at: rand(10.days).ago
  },
  {
    body: Faker::Lorem.sentence,
    sender_user_id: 12,
    recipient_user_id: 2,
    created_at: rand(10.days).ago
  },
  {
    body: Faker::Lorem.sentence,
    sender_user_id: 2,
    recipient_user_id: 15,
    created_at: rand(10.days).ago
  }    
]

SeedData.new('Message').load(data)