require "./db/seed_data"

data = [
  {:name => 'Central', :offset => 2},
  {:name => 'Eastern', :offset => 3},
  {:name => 'London', :offset => 8},
  {:name => 'Mountain', :offset => 1},
  {:name => 'Pacific', :offset => 0},
  {:name => 'Singapore', :offset => 16},
  {:name => 'Sydney', :offset => 18}
]

SeedData.new('Timezone').load(data)