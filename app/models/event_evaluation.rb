class EventEvaluation < ActiveRecord::Base
  include User::Associations
  belongs_to :event
  belongs_to :user_role
  validates :event_id, presence: true
  validates :user_role_id, presence: true
  validates :survey_link, presence: true, uniqueness: { scope: :event_id }
  default_scope { order :display_rank, :created_at }

end
