class NavigationRightSerializer < ActiveModel::Serializer
  attributes :show_attendees, :show_sessions, :show_my_schedule, :show_sponsors, :show_speakers, :show_qr_scannable, :show_qr_scanner, :show_event_notes, :show_bookmarks, :show_leaderboard, :show_leaderboard_rules, :show_event_evaluations
end