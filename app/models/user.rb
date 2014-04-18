class User < ActiveRecord::Base
  include User::Associations
  include User::Permissions

  devise :database_authenticatable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :alt_email, uniqueness: true, allow_nil: true
  validate :email_address_uniqueness

  has_many :group_members
  has_many :group_invites
  has_many :group_requests
  has_many :groups, through: :group_members
  has_many :sponsor_users
  has_many :event_users
  has_many :event_staff_users
  has_many :event_followers
  has_many :notifications, foreign_key: :notification_user_id
  has_many :event_speaker
  has_many :app_settings
  has_many :event_speakers
  has_many :event_notes, foreign_key: :created_by


  has_many :posts, foreign_key: :created_by
  has_many :post_likes
  has_many :post_comments
  has_many :following_events, through: :event_followers, source: :event
  has_many :user_events, through: :event_users, source: :event
  has_many :sender_connections, class_name: 'UserConnection', foreign_key: :sender_user_id
  has_many :recipient_connections, class_name: 'UserConnection', foreign_key: :recipient_user_id
  belongs_to :user_role

  default_scope { order :last_name }

  after_save :send_notification_after_change

  ### group related methods ###

  def viewable_groups
    (self.group_memberships + Group.open_groups).uniq
  end

  def self.group_invite_search(query: query, group: group)
    return if query.nil? || group.nil?
    query += "%"
    User.unscoped.select("DISTINCT users.id, users.first_name, users.last_name, users.title, users.organization_name, users.photo").
    joins("LEFT JOIN group_members ON group_members.user_id = users.id").
    where(%q{group_id != ? AND (first_name LIKE ? OR last_name LIKE ?)}, group.id, query, query)
  end

  def allowed_to_update_group?(group)
    raise ApiAccessEvanta::PermissionDenied if group.secret? && !group.group_owner?(self) && self.group_member?(group)
    raise ActiveRecord::RecordNotFound if group.secret? && !group.group_owner?(self)
    raise ApiAccessEvanta::PermissionDenied if !group.group_owner?(self)
    true
  end

  def group_member?(group)
    self.group_members.where(group: group).present?
  end

  def group_memberships
    groups
  end

  def open_group_memberships
    groups.joins(:group_type).
    where(group_types: {is_group_visible: true}).
    where(group_types: {is_memberlist_visible: true}).
    where(group_types: {is_content_visible: true}).
    where(group_types: {is_approval_required: false})
  end

  def private_group_memberships
    groups.joins(:group_type).
    where(group_types: {is_group_visible: true}).
    where(group_types: {is_memberlist_visible: false}).
    where(group_types: {is_content_visible: false}).
    where(group_types: {is_approval_required: true})
  end

  def secret_group_memberships
    groups.joins(:group_type).
    where(group_types: {is_group_visible: false}).
    where(group_types: {is_memberlist_visible: false}).
    where(group_types: {is_content_visible: false}).
    where(group_types: {is_approval_required: true})
  end


  ### event related methods ###

  def event_notes_for_user(user)
    return [] unless AppSettings::Value.new(:user_event_notes, user: self).on?
    (event_notes.where(event_user_id: user.event_users.map(&:id)) + event_notes.where(event_speaker_id: user.event_speakers.map(&:id))).sort_by(&:created_at)
  end

  def event_evaluations(event = nil)
    user_events = self.user_events.where("events.id = ?", event.id).map(&:id) if event.present?
    user_events = self.user_events.map(&:id) if event.nil?
    return EventEvaluation.where("event_id in (?) and user_role_id = ?", user_events, self.user_role_id).order(:display_rank, :created_at) if self.event_evaluations?
    []
  end

  def todays_events
    Event.today.joins(event_users: :event_registration_status).
    where(event_users: {user_id: id}, event_registration_statuses: {key: ["registered", "attended"]})
  end

  def event_user?(event)
    event_user(event).present?
  end

  def event_user(event)
    self.event_users.where(event: event).first
  end

  def event_user_or_group_member?(event)
    return true if group_member?(event.group) || event_user?(event)
    false
  end

  def my_schedule(event: event)
    event_user = event_user(event)
    return false if event_user.nil?
    EventSession.joins(:event_user_schedules).where(event_user_schedules: {event_user: event_user})
  end

  def add_session_to_my_schedule(event_session)
    event_user = event_user(event_session.event)
    raise ApiAccessEvanta::PermissionDenied if event_user.nil?
    EventUserSchedule.new(event_user_id: event_user.id, event_session: event_session)
  end

  def my_events
    group_events = Event.select("DISTINCT events.*").
    joins("LEFT JOIN event_users ON event_users.event_id = events.id").
    joins("LEFT JOIN event_followers ON event_followers.event_id = events.id").
    joins("LEFT JOIN event_sessions ON event_sessions.event_id = events.id").
    joins("LEFT JOIN event_speakers ON event_speakers.event_session_id = event_sessions.id").
    where("event_users.user_id = ? OR event_followers.user_id = ? OR event_speakers.user_id = ?", self.id, self.id, self.id).
    where("group_id IN (?)", self.group_members.map(&:group_id))
    Event.where(id: (self.event_users.map(&:event_id) + group_events.map(&:id).uniq))
  end

  def attended_events #(groups = nil)
    return [] if AppSettings::Value.new(:view_attended_events, user: self).off?
    query = event_users.joins(:event_registration_status, :event).where(event_registration_statuses: {key: "attended"})
    query.map(&:event)
  end

  def past_events
    if AppSettings::Value.new(:view_events_not_a_part_of, user: self).on?
      Event.past.where("group_id IN (?) OR id IN(?)", self.group_members.map(&:group_id), event_users.map(&:event_id) )
    else
      my_events.past
    end
  end

  def future_events
    if AppSettings::Value.new(:view_events_not_a_part_of, user: self).on?
      Event.upcoming.where("group_id IN (?) OR id IN(?)", self.group_members.map(&:group_id), event_users.map(&:event_id) ).reorder('begin_date ASC', :name)
    else
      my_events.upcoming.reorder('begin_date ASC', :name)
    end
  end

  ### post related methods ###

  def post_count
    self.posts.count
  end

  def post_like_count
    self.post_likes.count
  end

  def post_comment_count
    self.post_comments.count
  end

  def post_likes_sorted_by_activity
    PostLike.includes(:post).
    joins("LEFT JOIN posts ON posts.id = post_likes.post_id").
    joins("LEFT JOIN events ON events.id = posts.event_id").    
    where("user_id = ?", self.id)
  end

  def viewable_posts_likes_sorted_by_activity(viewable_to_user)
    viewable_post_related_stuff(viewable_to_user, post_likes_sorted_by_activity)
  end

  def posts_sorted_by_activity
    Post.unscoped.select("DISTINCT posts.*").includes([:post_likes, :post_comments, :post_attachments]).
    joins("LEFT JOIN post_likes ON post_likes.post_id = posts.id").
    joins("LEFT JOIN post_comments ON post_comments.post_id = posts.id").
    joins("LEFT JOIN post_attachments ON post_attachments.post_id = posts.id").
    joins("LEFT JOIN events ON events.id = posts.event_id").
    where("posts.created_by = ?", self.id).
    order("GREATEST(posts.created_at, COALESCE(post_likes.created_at, 0), COALESCE(post_comments.created_at, 0), COALESCE(post_attachments.created_at, 0)) DESC")
  end

  def viewable_posts_sorted_by_activity(viewable_to_user)
    viewable_post_related_stuff(viewable_to_user, posts_sorted_by_activity)
  end

  def viewable_post_related_stuff(viewable_to_user, post_relation)

    group_ids = viewable_to_user.viewable_groups.map(&:id)
    event_ids = viewable_to_user.user_events.map(&:id)

    return [] if group_ids.count == 0 && event_ids.count == 0

    post_group = "(posts.group_id IS NOT NULL AND posts.event_id IS NULL AND posts.group_id IN (?))"
    event_group = "(events.group_id IS NOT NULL AND posts.group_id IS NULL AND events.group_id IN (?))"
    events = "(events.id IS NOT NULL AND events.id IN (?))"

    if group_ids.count > 0 && event_ids.count > 0
      return post_relation.where([post_group,event_group,events].join(" OR "), group_ids, group_ids, event_ids)
    end

    if group_ids.count == 0 && event_ids.count > 0
      return post_relation.where(events, event_ids)
    end

    if group_ids.count > 0 && event_ids.count == 0
      return post_relation.where([post_group,event_group].join(" OR "), group_ids, group_ids)
    end

  end

  ### messages related methods ###

  def new_message_count
    Message.where('(recipient_user_id = ? AND viewed_date IS NULL)', id).count
  end

  def allowed_to_send_message?(user)
    raise ActiveRecord::RecordNotFound if user.nil?

    # Not allowed to send your self a message
    raise ApiAccessEvanta::PermissionDenied if user.id == self.id

    true
  end

  ### connections related methods ###

  def user_connection_count
    return unless AppSettings::Value.new(:show_connections_count, user: self).on?
    return unless AppSettings::Value.new(:block_viewing_my_connections, user: self).on?
    UserConnection.where('(sender_user_id = ? OR recipient_user_id = ?)', id, id).approved.count
  end

  def user_connections
    sender_connections + recipient_connections
  end

  def approved_user_connections
    sender_connections.approved + recipient_connections.approved
  end

  def users_pending_connection
    (recipient_connections.pending.map(&:sender_user) + sender_connections.pending.map(&:recipient_user)).uniq
  end

  def users_connected_to
    (recipient_connections.approved.map(&:sender_user) + sender_connections.approved.map(&:recipient_user)).uniq
  end

  def connected_to_user(user)
    UserConnection.where('(sender_user_id = ? AND recipient_user_id = ?) OR (sender_user_id = ? AND recipient_user_id = ?)', id, user.id, user.id, id).first
  end

  ### misc methods ###

  def full_name
    "#{first_name} #{last_name}"
  end

  def new_notification_count
    self.notifications.where('is_viewed = 0').count
  end

  def send_notification_after_change
    users_to_notify = approved_user_connections.map(&:sender_user) + approved_user_connections.map(&:recipient_user) - [self]
    users_to_notify.each do |user_to_notify|
      next if !user_to_notify.notifications?
      Notification.create(body: "#{full_name} title has changed to \"#{title}\".", notification_user: user_to_notify, user: self) if title_changed?
      Notification.create(body: "#{full_name} organization has changed to \"#{organization_name}\".", notification_user: user_to_notify, user: self) if organization_name_changed?
    end
  end

  def active_for_authentication?
    super && account_active?
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

  private

    def email_address_uniqueness
      if alt_email.present? && User.where(email: alt_email).count > 0
        errors.add(:alt_email, "has already been taken")
      end

      if email.present? && User.where(alt_email: email).count > 0
        errors.add(:email, "has already been taken")
      end
    end

    def generate_authentication_token
      loop do
        token = Devise.friendly_token
        break token unless User.where(authentication_token: token).first
      end
    end

end
