require "./db/seed_data"

def random
  [true, false].sample
end

data = [
{ sender_user_id: 1, recipient_user_id: 2, created_by: 1 },
{ sender_user_id: 1, recipient_user_id: 3, created_by: 1 },
{ sender_user_id: 1, recipient_user_id: 4, created_by: 1 },
{ sender_user_id: 1, recipient_user_id: 5, created_by: 1 },
{ sender_user_id: 1, recipient_user_id: 6, created_by: 1 },
{ sender_user_id: 1, recipient_user_id: 7, created_by: 1 },
{ sender_user_id: 1, recipient_user_id: 8, created_by: 1 },
{ sender_user_id: 2, recipient_user_id: 3, created_by: 2 },
{ sender_user_id: 2, recipient_user_id: 4, created_by: 2 },
{ sender_user_id: 2, recipient_user_id: 5, created_by: 2 },
{ sender_user_id: 2, recipient_user_id: 6, created_by: 2 },
{ sender_user_id: 2, recipient_user_id: 7, created_by: 2 },
{ sender_user_id: 2, recipient_user_id: 8, created_by: 2 },
{ sender_user_id: 3, recipient_user_id: 4, created_by: 3 },
{ sender_user_id: 3, recipient_user_id: 5, created_by: 3 },
{ sender_user_id: 3, recipient_user_id: 6, created_by: 3 },
{ sender_user_id: 3, recipient_user_id: 7, created_by: 3 }
]

SeedData.new('UserConnection').load(data)

UserConnection.all.each do |user_connection|
  user_connection.approve if random
end
