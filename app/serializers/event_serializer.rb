class EventSerializer < ActiveModel::Serializer

  attributes :id, :name, :begin_date, :end_date, :venue_name, :address, :state, :postal_code, :event_follower_id, :registraion_status, :user_today_event, :can_follow_event, :allow_notes, :allow_bookmarks
  has_one :country
  has_one :timezone
  has_one :group, serializer: GroupTinySerializer
  has_many :attendees, serializer: EventUserAttendeeSerializer
  has_many :sponsors, serializer: SponsorShortSerializer
  has_many :event_staff, serializer: UserShortSerializer
  has_many :event_evaluations

  def event_evaluations
    object.get_event_evaluations(scope)
  end

  def event_follower_id
    EventFollower.where(user_id: current_user.id, event_id: self.id).first.try(:id)
  end

  def registraion_status
    event_user = EventUser.where(user_id: current_user.id, event_id: self.id).first
    registration_status = EventRegistrationStatus.find(event_user.event_registration_status_id).key if event_user && !event_user.event_registration_status_id.nil?
  end

  def user_today_event
    object.user_today_event?(scope)
  end

  def can_follow_event
    object.can_follow_event?
  end

  def attendees
    return object.attendees_excluding_hidden if object.show_attendees?(current_user)
    []
  end

  def event_sponsors
    object.event_sponsors if object.show_event_sponsors?(scope)
  end

  def allow_notes
    AppSettings::Value.new(:event_notes, event: object, user: scope).on?
  end

  def allow_bookmarks
    AppSettings::Value.new(:event_bookmarks, event: object, user: scope).on?
  end



end
