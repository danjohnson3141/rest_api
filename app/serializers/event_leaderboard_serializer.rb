class EventLeaderboardSerializer < ActiveModel::Serializer
  attributes :id, :points_allocated, :event_leaderboard_option_id, :created_by, :updated_by
end
