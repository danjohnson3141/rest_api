require "./db/seed_data"

data = []
Sponsor.all.each do |sponsor|
data += [ { sponsor: sponsor, user: SeedData.get_random(User) } ]
end

SeedData.new('SponsorUser').load(data)
