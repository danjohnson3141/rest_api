class Group < ActiveRecord::Base
  include User::Associations
  belongs_to :group_type
  has_many :group_members
  has_many :group_invites
  has_many :group_requests
  has_many :posts
  has_many :group_invite_users, through: :group_invites, source: :user
  has_many :group_request_users, through: :group_requests, source: :user
  has_many :group_member_users, through: :group_members, source: :user
  has_many :notifications
  has_many :events
  has_many :featured_posts, through: :posts, source: :featured_post
  belongs_to :owner, class_name: 'User', foreign_key: 'owner_user_id'
  has_many :sponsors

  validates :name, uniqueness: {case_sensitive: false}, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :group_type_id, presence: true
  validates :owner_user_id, presence: true

  after_save :notify_connections_of_group_creation

  def self.filtered_list(user)
    Group.joins(:group_type).
    order(:name).
    where("group_types.is_group_visible = 1 OR groups.id IN (?)", user.group_members.map(&:group_id))
  end

  def pending_group_invites
    group_members_user_ids = group_members.map(&:user_id)

    group_invites.includes(:user).
    order("users.last_name, users.first_name").
    reject { |group_invite| group_members_user_ids.include?(group_invite.user_id) }
  end

  def pending_group_requests
    group_requests.includes(:user).
    order("users.last_name, users.first_name").
    where(is_approved: 0)
  end

  def filtered_group_members
    group_members.includes(:user).
    order("users.last_name, users.first_name").
    select { |group_member| AppSettings::Value.new(:show_me_on_lists, user: group_member.user, group: self).on? }
  end

  def allow_post_creation?(user)
    return AppSettings::Value.new(:create_group_posts, user: user, group: self).on? if user.group_member?(self)
    false
  end

  def show_group?(user)
    raise ActiveRecord::RecordNotFound if self.nil?
    raise ActiveRecord::RecordNotFound if self.secret? && !self.group_owner?(user) && !user.group_member?(self)
    return true if self.group_owner?(user) || user.group_member?(self) || !self.secret?
  end

  def show_member_list?(user)
    if AppSettings::Value.new(:show_group_member_list, group: self, user: user).on?
      return true if self.group_type.is_memberlist_visible
      return true if user.group_member?(self)
    end
    false
  end

  def group_owner?(user)
    return true if self.owner_user_id == user.id
    false
  end

  def hide_app_sponsors?
    AppSettings::Value.new(:hide_app_sponsors_on_group, group: self).off?
  end

  def self.open_groups
    self.joins(:group_type).where(group_types: {is_approval_required: false})
  end

  def open?
    return false if self.group_type.is_group_visible != true
    return false if self.group_type.is_memberlist_visible != true
    return false if self.group_type.is_content_visible != true
    return false if self.group_type.is_approval_required != false
    true
  end

  def private?
    return false if self.group_type.is_group_visible != true
    return false if self.group_type.is_memberlist_visible != false
    return false if self.group_type.is_content_visible != false
    return false if self.group_type.is_approval_required != true
    true
  end

  def secret?
    return false if self.group_type.is_group_visible != false
    return false if self.group_type.is_memberlist_visible != false
    return false if self.group_type.is_content_visible != false
    return false if self.group_type.is_approval_required != true
    true
  end

  def notify_connections_of_group_creation
    if open?
      users_to_notify = owner.approved_user_connections.map(&:sender_user) + owner.approved_user_connections.map(&:recipient_user) - [owner]
      users_to_notify.each do |user_to_notify|
        next if !user_to_notify.notifications?
        body = "#{owner.full_name} has created group \"#{name}\"."
        Notification.create(body: body, notification_user: user_to_notify, group: self, user: owner)
      end
    end
  end
end
