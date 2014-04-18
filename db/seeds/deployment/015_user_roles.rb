require "./db/seed_data"

data = [ 
  {:id => 1, :name => 'User_all'}, 
  {:id => 2, :name => 'Guest'}, 
  {:id => 3, :name => 'Member'}, 
  {:id => 4, :name => 'Sponsor'},
  {:id => 5, :name => 'Former'} 
]

SeedData.new('UserRole').load(data)