require "./db/seed_data"

data = [
  {
    :id => 1,
    :name => 'National Sponsor',
    :description => Faker::Company.catch_phrase,
    display_rank: 10
  },
  {
    :id => 2,
    :name => 'Enterprise Sponsor',
    :description => Faker::Company.catch_phrase,
    display_rank: 20
  },
  {
    :id => 3,
    :name => 'Event Sponsor',
    :description => Faker::Company.catch_phrase,
    display_rank: 30
  },
  {
    :id => 4,
    :name => 'Hospitality Sponsor',
    :description => Faker::Company.catch_phrase,
    display_rank: 40
  },
  {
    :id => 5,
    :name => 'Contributing Sponsor',
    :description => Faker::Company.catch_phrase,
    display_rank: 50
  },
  {
    :id => 6,
    :name => Faker::Name.title,
    :description => Faker::Company.catch_phrase,
    display_rank: 60
  }
]

SeedData.new('SponsorType').load(data)