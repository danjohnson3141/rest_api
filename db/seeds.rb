Bullet = "\u2022"
# Run all other seed files in seeds/deployment directory.
# These are deployed into production.
if Rails.env != "test"
  puts "\n#{Bullet} Deployment Seeding:".green
  puts '--------------------------------------------------------------------------------------------'.green
  Dir[File.join(Rails.root, 'db', 'seeds', 'deployment', '*.rb')].sort.each { |seed| load seed }

  # Run all other seed files in seeds/development directory.
  # These are not deployed into production.
  puts "\n#{Bullet} Development Seeding:".green
  puts '--------------------------------------------------------------------------------------------'.green
  Dir[File.join(Rails.root, 'db', 'seeds', 'development', '*.rb')].sort.each { |seed| load seed }
end

# Seeds for test only
# These are not deployed into production.

# if Rails.env == "test"
#   puts "\nTest Seeding:".green
#   puts '--------------------------------------------------------------------------------------------'.green
#   Dir[File.join(Rails.root, 'db', 'seeds', 'test', '*.rb')].sort.each { |seed| load seed }
# end