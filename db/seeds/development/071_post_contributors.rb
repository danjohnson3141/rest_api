require "./db/seed_data"

data = []
10.times do
  post_id = SeedData.get_random(Post).id
  data += [ { user_id: SeedData.get_random(User).id, post_id: post_id, created_by: SeedData.get_random(User).id } ]
  data += [ { user_id: SeedData.get_random(User).id, post_id: post_id, created_by: SeedData.get_random(User).id } ]
end

SeedData.new('PostContributor').load(data)