class EventUser < ActiveRecord::Base
  include User::Associations
  belongs_to :event_registration_status
  belongs_to :user
  belongs_to :event
  belongs_to :sponsor
  has_many :event_notes
  has_many :event_bookmarks

  validates :user_id, presence: true, uniqueness: { scope: :event_id }
  validates :event_id, presence: true

  after_save :create_event_follower, :notify_connections_of_registration

  def note_for_user(user)
    EventNote.where(event_user_id: self.id).where(created_by: user.id).first
  end

  def bookmark_for_user(user)
    EventBookmark.where(event_user_id: self.id).where(created_by: user.id).first
  end

  def create_event_follower
    EventFollower.create(event: self.event, user: self.user) if EventFollower.where(event: self.event, user: self.user).first.nil?
  end

  def notify_connections_of_registration
    if event_registration_status == EventRegistrationStatus.find_by_key('registered')
      users_to_notify = user.approved_user_connections.map(&:sender_user) + user.approved_user_connections.map(&:recipient_user) - [user]
      users_to_notify.each do |user_to_notify|
        next if !user_to_notify.notifications?
        body = "#{user.full_name} has registered for #{event.name}."
        Notification.create(body: body, notification_user: user_to_notify, user: user, event: event)
      end
    end
  end

end
