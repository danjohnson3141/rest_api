class GroupInvite < ActiveRecord::Base
  include User::Associations
  belongs_to :user
  belongs_to :group
  has_many :notification, dependent: :delete_all 
  validate :already_group_member
  validates :user_id, presence: true, uniqueness: { scope: :group_id }
  validates :group_id, presence: true
  after_save :check_pending_group_requests


  def self.check_read_permission(group_id, current_user)
    group = Group.find_by_id(group_id)

    raise ActiveRecord::RecordNotFound if group.nil?
    raise ActiveRecord::RecordNotFound if group.secret? && !group.group_owner?(current_user) && !current_user.group_member?(group)
    return true if group.owner_user_id == current_user.id

    raise ApiAccessEvanta::PermissionDenied
  end

  def self.check_write_permission(current_user, params)
    group = Group.find(params['group_id'])
    user = User.find(params['user_id'])
    raise ActiveRecord::RecordNotFound if group.secret? && !group.group_owner?(current_user) && !current_user.group_member?(group)
    return true if group.owner_user_id == current_user.id && user.can_join_groups?
    raise ApiAccessEvanta::PermissionDenied
  end

  def approve_pending_group_request
    GroupRequest.where(user: self.user, group: self.group).first.try(:approve)
  end

  def pending_group_request?
    GroupRequest.where(user: self.user, group: self.group).exists?
  end

  private

    def check_pending_group_requests
      if pending_group_request?
        approve_pending_group_request
        create_group_member if !group_member?
      else
        notify_user
      end
    end

    def group_member?
      GroupMember.where(user: user, group: group).exists?
    end

    def create_group_member
      GroupMember.create(user: user, group: group)
    end

    def notify_user
      return if !user.notifications?
      body = "You've been invited to join #{self.group.name}."
      Notification.create(body: body, notification_user: user, group: group, user: group.owner, group_invite: self)
    end

    # Custom validator
    def already_group_member
      group = Group.find(group_id)
      user = User.find(user_id)
      if user.group_member?(group)
        errors.add(:group_member, "Cannot invite users that are current group members")
      end
    end


end
