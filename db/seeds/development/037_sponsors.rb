require "./db/seed_data"

def get_random_image

  images = []
  images << "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQVBb4xr92pQGIVp5H_HTOQbokabjl10Tc4bMQs9AeAWWBMA40T"
  images << "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGDiKm_65gd8W3rldaiIcnBPa5xdeV_TjV-I0h-a7Mkc9zyKa2"
  images << "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRZSKKQMA8LU8CVIN_9xVU6R87Z6ijFN290bfRFmK3x6-iWH4Bi"
  images << "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRGewb1V7HhET93s08W7G0Zv79DQO3o-8X-nSm9jY8fky8cH-h0"
  images << "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTvGG2FajNhzpotZNYL1pjD7bLbAdZZMahlCrPrPyozfoZ61etV_Q"
  images << "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcQ0z7mYMQSBDKbNSjv_VRyL7YH8WHO_groLkv9JwoH9c5kYGYqF"
  images << "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR-HirQPm_YY39HkSLo1wS59SmXhjkzy22uj0QKUhFObJqmtsqIxg"
  images << "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcSppjZDdfpI0OEBM8bD0R1gwi_d4PXFLTx6Glazklt5AUDXd9zc7g"
  images << "https://encrypted-tbn2.gstatic.com/images?q=tbn:ANd9GcTSY6ZYMzmbVv398vIJwVylS76iA45LwDfP84FJAYXYoKUzmwfl"

  images.sample
end
type_count = SponsorType.count

data = [
  { name: Faker::Company.name,
    sponsor_type_id: [*1..type_count].sample,
    description: Faker::Company.catch_phrase,
    logo: get_random_image,
    url: Faker::Internet.url,
    splash_sponsor: true
  }
]

(1..20).each do |x|
  data += [
    { name: Faker::Company.name,
      sponsor_type_id: [*1..type_count].sample,
      description: Faker::Company.catch_phrase,
      logo: get_random_image,
      url: Faker::Internet.url,
    }
  ]
end

groups = Group.limit(3)
groups.each do |group|
  data += [
    { name: Faker::Company.name,
      sponsor_type_id: [*1..type_count].sample,
      description: Faker::Company.catch_phrase,
      logo: get_random_image,
      url: Faker::Internet.url,
      group_id: group.id
    }
  ]
end


(1..30).each do |x|
  data += [
    { name: Faker::Company.name,
      sponsor_type_id: [*1..type_count].sample,
      description: Faker::Company.catch_phrase,
      logo: get_random_image,
      url: Faker::Internet.url,
      event_id: SeedData.get_random(Event).id
    }
  ]
end

SeedData.new('Sponsor').load(data)