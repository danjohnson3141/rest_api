class GroupRequest < ActiveRecord::Base
  include User::Associations
  belongs_to :user
  belongs_to :group
  scope :approved, -> { where(is_approved: true) }
  scope :not_approved, -> { where(is_approved: false) }
  default_scope { order(:created_at) }
  validates :user_id, uniqueness: { scope: :group_id }
  after_save :check_pending_group_invites

  def approve
    self.update_columns(is_approved: true)
    create_group_member if !group_member?
    notify_user
  end

  def pending_group_invite?
    GroupInvite.where(user: self.user, group: self.group).exists?
  end

  private

    def check_pending_group_invites
      if pending_group_invite?
        approve
      end
    end

    def group_member?
      GroupMember.where(user: user, group: group).exists?
    end

    def create_group_member
      GroupMember.create(user: user, group: group) if is_approved?
    end

    def notify_user
      return true if !user.notifications?
      body = "Your request to join #{group.name} has been approved."
      Notification.create(body: body, notification_user: user, group: group, user: group.owner)
    end

end
