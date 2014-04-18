class EventStaffUser < ActiveRecord::Base
  include User::Associations
  belongs_to :user
  belongs_to :event

  validates :user_id, presence: true, uniqueness: { scope: :event_id }
  validates :event_id, presence: true

  after_save :create_event_user

  def create_event_user
    EventUser.create(event: self.event, user: self.user, event_registration_status: EventRegistrationStatus.find_by_key('registered')) if EventUser.where(event: self.event, user: self.user).first.nil?
  end
end
