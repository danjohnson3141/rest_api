class GroupMember < ActiveRecord::Base
  include User::Associations
  belongs_to :group
  belongs_to :user

  validates :user_id, presence: true, uniqueness: { scope: :group_id }
  validates :group_id, presence: true

  after_save :notify_owner

  def is_user_invited?
    !GroupInvite.where(group_id: self.group_id, user_id: self.user_id).first.nil?
  end

  def is_request_approved?
    !GroupRequest.where(group_id: self.group_id, user_id: self.user_id, is_approved: true).first.nil?
  end
 
  def notify_owner
    return if !group.owner.notifications? || group.owner == user
    body = "#{user.full_name} has joined your group \"#{group.name}\"."
    Notification.create(body: body, notification_user: group.owner, group: group, user: user)
  end


  # only current user is allowed to join a group.
  # if group type requires approval an approved group request or group invitation must exist
  def check_permission
    raise ActiveRecord::RecordNotFound if self.user.nil?
    raise ActiveRecord::RecordNotFound if self.group.nil?
    return true if !group.group_type.is_approval_required && self.user.can_join_groups?
    return true if (self.is_user_invited? || self.is_request_approved?) && self.user.can_join_groups?
    raise ApiAccessEvanta::RecordOutOfScope if self.group.secret? && !self.is_user_invited?
    raise ApiAccessEvanta::PermissionDenied
  end


end
