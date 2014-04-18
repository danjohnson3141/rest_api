# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'simplecov'
require 'colorize'

SimpleCov.start
# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Bullet = "\u2022"

# def clear_app_settings
#   AppSettingDependency.destroy_all
#   AppSettingOption.destroy_all
#   AppSettingType.destroy_all
# end

def load_seed_data
  bullet
  print " Loading seed data".green
  load "db/seeds/deployment/001_app_setting_types.rb"
  load "db/seeds/deployment/002_app_setting_options.rb"
  load "db/seeds/deployment/003_app_setting_dependencies.rb"
  load "db/seeds/deployment/010_app_label_pages.rb"
  load "db/seeds/deployment/011_app_label_dictionaries.rb"
  load "db/seeds/deployment/015_user_roles.rb"
  load "db/seeds/deployment/030_event_registration_statuses.rb"
  step_complete
end

def reset_auto_increment
  bullet
  print " Reseting auto increment".green
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.execute("ALTER TABLE #{table} AUTO_INCREMENT = 1")
  end
  step_complete
end

def truncate_all_tables
  bullet
  print " Truncating all tables".green
  ActiveRecord::Base.connection.execute("SET foreign_key_checks = 0;")
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table}") unless table == 'schema_migrations'
  end
  ActiveRecord::Base.connection.execute("SET foreign_key_checks = 1;")
  step_complete
end

def truncate_non_seed_tables
  save_tables = ['app_setting_types', 'app_setting_options', 'app_setting_dependencies', 'app_label_pages', 'app_label_dictionaries', 'event_registration_statuses', 'user_roles', 'schema_migrations']
  ActiveRecord::Base.connection.execute("SET foreign_key_checks = 0;")
  ActiveRecord::Base.connection.tables.each do |table|
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table}") unless save_tables.include?(table)
  end
  ActiveRecord::Base.connection.execute("SET foreign_key_checks = 1;")
end

def step_complete
  puts " \u2713".blue
end

def bullet
  print Bullet.white
end

RSpec.configure do |config|
  config.before(:suite) do
    puts "Before suite setup:".yellow
    reset_auto_increment
    truncate_all_tables
    load_seed_data
  end

  config.after(:suite) do
    puts
    puts "After suite cleanup:".yellow
    truncate_all_tables
  end

  config.after(:all) do
    truncate_non_seed_tables
  end  

  # config.before(:all) do
  #   truncate_non_seed_tables
  # end

  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"

  config.include FactoryGirl::Syntax::Methods

  config.include RSpec::Rails::RequestExampleGroup

  config.include Requests::JsonHelpers, type: :request

  config.include Requests::Extensions, type: :request
end
