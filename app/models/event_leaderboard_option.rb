class EventLeaderboardOption < ActiveRecord::Base
  include User::Associations
  has_many :event_leaderboard
end
