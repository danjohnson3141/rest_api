require "./db/seed_data"
data = [
  {
    id: 1,
    name: "2014 HOU CIO ES",
    begin_date: "2014-01-22",
    end_date:  "2014-01-23",
    venue_name: "Marriot",
    address: Faker::Address.street_address,
    state: "TX",
    postal_code: Faker::Address.zip_code,
    country_id: 1,
    timezone_id: 2, 
    group_id: 1
  },
  {
    id: 2,
    name: "2014 NYC CIO ES",
    begin_date: "2014-02-22",
    end_date:  "2014-02-23",
    venue_name: "Marriot",
    address: Faker::Address.street_address,
    state: "NY",
    postal_code: Faker::Address.zip_code,
    country_id: 1,
    timezone_id: 2,
    group_id: 1
  },
  {
    id: 3,
    name: "2014 BOS CISO ES",
    begin_date: "2014-01-02",
    end_date:  "2014-01-03",
    venue_name: "Hilton",
    address: Faker::Address.street_address,
    state: "MA",
    postal_code: Faker::Address.zip_code,
    country_id: 1,
    timezone_id: 2, 
    group_id: 2
  },
  {
    name: "2013 HOU CIO ES",
    begin_date: "2013-01-22",
    end_date:  "2013-01-23",
    venue_name: "Marriot",
    address: Faker::Address.street_address,
    state: "TX",
    postal_code: Faker::Address.zip_code,
    country_id: 1,
    timezone_id: 2, 
    group_id: 1
  },
  {
    name: "2013 NYC CIO ES",
    begin_date: "2013-02-22",
    end_date:  "2013-02-23",
    venue_name: "Marriot",
    address: Faker::Address.street_address,
    state: "NY",
    postal_code: Faker::Address.zip_code,
    country_id: 1,
    timezone_id: 2,
    group_id: 1
  },
  {
    name: "2013 BOS CISO ES",
    begin_date: "2013-01-02",
    end_date:  "2013-01-03",
    venue_name: "Hilton",
    address: Faker::Address.street_address,
    state: "MA",
    postal_code: Faker::Address.zip_code,
    country_id: 1,
    timezone_id: 2, 
    group_id: 2
  },
  {
    name: "2015 HOU CIO ES",
    begin_date: "2015-01-22",
    end_date:  "2015-01-23",
    venue_name: "Marriot",
    address: Faker::Address.street_address,
    state: "TX",
    postal_code: Faker::Address.zip_code,
    country_id: 1,
    timezone_id: 2, 
    group_id: 1
  },
  {
    name: "2015 NYC CIO ES",
    begin_date: "2015-02-22",
    end_date:  "2015-02-23",
    venue_name: "Marriot",
    address: Faker::Address.street_address,
    state: "NY",
    postal_code: Faker::Address.zip_code,
    country_id: 1,
    timezone_id: 2,
    group_id: 1
  },
  {
    name: "2015 BOS CISO ES",
    begin_date: "2015-01-02",
    end_date:  "2015-01-03",
    venue_name: "Hilton",
    address: Faker::Address.street_address,
    state: "MA",
    postal_code: Faker::Address.zip_code,
    country_id: 1,
    timezone_id: 2, 
    group_id: 2
  }
]

SeedData.new('Event').load(data)