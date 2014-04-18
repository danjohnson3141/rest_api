# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
ApiAccessEvanta::Application.initialize!

ActionMailer::Base.smtp_settings = {
  :user_name => 'evanta',
  :password => 'BridgeHills04',
  :domain => 'email.leadershipnetwork.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}