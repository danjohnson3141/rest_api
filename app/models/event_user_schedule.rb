class EventUserSchedule < ActiveRecord::Base
  include User::Associations
  belongs_to :event_session
  belongs_to :event_user

  validates :event_user_id, presence: true, uniqueness: { scope: :event_session_id }
  validates :event_session_id, presence: true
end
