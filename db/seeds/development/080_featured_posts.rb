require "./db/seed_data"

data = []
20.times do
  data += [ { post_id: SeedData.get_random(Post).id } ]
end

SeedData.new('FeaturedPost').load(data)
