require "./db/seed_data"

data = [
  { :user_id => 1, :group_id => 5 },
  { :user_id => 2, :group_id => 5 },
  { :user_id => 3, :group_id => 5 },
  { :user_id => 4, :group_id => 5 },
  { :user_id => 5, :group_id => 5 },
  { :user_id => 6, :group_id => 5 },
  { :user_id => 7, :group_id => 5 },
  { :user_id => 8, :group_id => 5 }
]

SeedData.new('GroupRequest').load(data)