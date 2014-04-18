class Event < ActiveRecord::Base
  include User::Associations
  belongs_to :country
  belongs_to :timezone
  belongs_to :group
  has_many :event_staff_users
  has_many :event_users
  has_many :event_followers
  has_many :banner_ads
  has_many :event_speakers, through: :event_sessions
  has_many :sponsors
  has_many :event_evaluations

  has_many :posts
  has_many :featured_posts, through: :posts, source: :featured_post
  has_many :event_sessions

  has_many :event_followers_users, through: :event_followers, source: :user
  has_many :event_users_users, through: :event_users, source: :user
  has_many :event_staff_user_users, through: :event_staff_users, source: :user

  validates :name, uniqueness: true, presence: true, length: { maximum: 255 }
  validates :begin_date, presence: true
  validates :end_date, presence: true
  validate :event_dates

  scope :past, -> { where("begin_date <= ?", Date.today) }
  scope :upcoming, -> { where("begin_date >= ?", Date.today) }
  scope :today, -> { where("begin_date <= ?", Date.today).where("end_date >= ?", Date.today) }
  default_scope { order('begin_date DESC', :name) }

  def get_event_evaluations(user)
    return EventEvaluation.where(event: self, user_role: user.user_role) if self.show_event_evaluations?(user)
    return []
  end

  def feed
    Post.unscoped.select("DISTINCT posts.*").includes([:post_likes, :post_comments, :post_attachments]).
    joins("LEFT JOIN event_sessions ON event_sessions.id = posts.event_session_id").
    joins("LEFT JOIN post_likes ON post_likes.post_id = posts.id").
    joins("LEFT JOIN post_comments ON post_comments.post_id = posts.id").
    joins("LEFT JOIN post_attachments ON post_attachments.post_id = posts.id").
    where("posts.event_id = ? OR event_sessions.event_id = ?", id, id).order("GREATEST(posts.created_at, COALESCE(post_likes.created_at, 0), COALESCE(post_comments.created_at, 0), COALESCE(post_attachments.created_at, 0)) DESC")
  end

  def event_staff
    self.event_staff_user_users.order(:last_name, :first_name)
  end

  def show_event_evaluations?(user)
    AppSettings::Value.new(:user_event_evaluations, user: user, event: self).on?
  end

  def show_event_sponsors?(user)
    AppSettings::Value.new(:event_sponsors, user: user, event: self).on?
  end

  def can_follow_event?
    AppSettings::Value.new(:event_follows).on?
  end

  def show_attendees?(user)
    AppSettings::Value.new(:show_attendees, user: user, event: self).on?
  end

  def show_sessions?(user)
    AppSettings::Value.new(:event_sessions, user: user, event: self).on?
  end

  def show_speakers?(user)
    AppSettings::Value.new(:event_speakers, user: user, event: self).on?
  end

  def attendees
    event_users.joins(:event_registration_status).includes(:user).where(event_registration_statuses: {key: get_registration_statuses_for_attendees}).order("users.last_name, users.first_name")
  end

  def attendees_excluding_hidden
    attendees.select { |event_user| AppSettings::Value.new(:show_me_on_lists, user: event_user.user, event: self).on? }
  end

  # Check app setting for:
  # At beginning of the event, switch attendee list to show only people marked "attended"
  def show_attendees_only?
    event_started? && AppSettings::Value.new(:show_attendees_only_after_event_starts, event: self).on?
  end

  def event_started?
    begin_date <= Time.now
  end

  def allow_notes?(user)
    AppSettings::Value.new(:event_notes, user: user, event: self).on?
  end

  def allow_bookmarks?(user)
    AppSettings::Value.new(:event_bookmarks, user: user, event: self).on?
  end

  def allow_post_creation?(user)
    return AppSettings::Value.new(:create_event_posts, user: user, event: self).on? if !user.event_user(self).nil?
    false
  end

  def notes(user)
    EventNote.for_event(event: self, user: user) if allow_notes?(user)
  end

  def bookmarks(user)
    EventBookmark.for_event(event: self, user: user) if allow_bookmarks?(user)
  end


  def user_today_event?(user)
    Event.today.joins(event_users: :event_registration_status).
    where(event_users: {user_id: user.id, event_id: self.id}, event_registration_statuses: {key: ["registered", "attended"]}).count > 0
  end

  private

    def get_registration_statuses_for_attendees
      return ["attended"] if show_attendees_only?

      ["registered", "attended"]
    end

    def event_dates
      return if begin_date.nil? || end_date.nil?
      errors.add(:event, "Event begin_date must occur before end_date") unless begin_date <= end_date
    end

end
