class EventSessionEvaluation < ActiveRecord::Base
  include User::Associations
  belongs_to :event_session
  has_one :event, through: :event_session, source: :event
  validates :event_session_id, presence: true
  validates :survey_link, presence: true, uniqueness: { scope: :event_session_id }
  default_scope { order :display_rank, :created_at }
end
