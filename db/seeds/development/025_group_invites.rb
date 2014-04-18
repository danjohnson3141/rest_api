require "./db/seed_data"

data = [
  { :user_id => 1, :group_id => 6 },
  { :user_id => 2, :group_id => 6 },
  { :user_id => 3, :group_id => 6 },
  { :user_id => 4, :group_id => 6 },
  { :user_id => 5, :group_id => 6 },
  { :user_id => 6, :group_id => 6 }
]

SeedData.new('GroupInvite').load(data)