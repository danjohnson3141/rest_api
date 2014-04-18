require "./db/seed_data"

data = [
  {:name => 'en', :description => 'United State English - Native Default Language'},
  {:name => "uk", :description => 'United Kingdom English'},
  {:name => 'fr', :description => 'French (Français)'}
]

SeedData.new('AppLanguage').load(data)