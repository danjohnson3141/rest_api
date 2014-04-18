class EventLeaderboard < ActiveRecord::Base
  include User::Associations
  belongs_to :event_leaderboard_option
end
