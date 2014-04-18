require "./db/seed_data"

data = [
  { user_id: 1, group_id: 1 }, { user_id: 1, group_id: 4 }, { user_id: 1, group_id: 5 }, 
  { user_id: 2, group_id: 1 }, { user_id: 2, group_id: 4 }, { user_id: 2, group_id: 5 }, 
  { user_id: 3, group_id: 1 }, { user_id: 3, group_id: 4 }, { user_id: 3, group_id: 5 }, 
  { user_id: 4, group_id: 1 }, { user_id: 4, group_id: 4 }, { user_id: 4, group_id: 5 }, 
  { user_id: 5, group_id: 1 }, { user_id: 5, group_id: 4 }, { user_id: 5, group_id: 5 }, 
  { user_id: 6, group_id: 1 }, { user_id: 6, group_id: 4 }, { user_id: 6, group_id: 5 }
]
20.times do
  data += [
    { user_id: SeedData.get_random(User).id, group_id: SeedData.get_random(Group).id }
  ]
end

SeedData.new('GroupMember').load(data)