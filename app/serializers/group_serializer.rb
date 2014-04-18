class GroupSerializer < ActiveModel::Serializer

  attributes :id, :name, :description, :owner_user_id, :member_count, :group_member_id, :group_request_id, :group_request_is_approved, :group_invite_id, :create_post, :leave_group, :hide_app_sponsors?
  has_one :group_type
  has_one :owner, serializer: UserShortSerializer
  has_many :group_sponsors
  has_many :group_members, serializer: GroupMemberUserSerializer
  has_many :group_invites, serializer: GroupInviteUserSerializer
  has_many :group_requests, serializer: GroupRequestUserSerializer

  def member_count
    object.group_member_users.count
  end

  def group_member_id
    GroupMember.select(:id).where(user_id: scope.id, group_id: object.id).first.try(:id)
  end

  def group_request_id
    GroupRequest.select(:id).where(user_id: scope.id, group_id: object.id).first.try(:id)
  end

  def group_request_is_approved
    GroupRequest.select(:is_approved).where(user_id: scope.id, group_id: object.id).first.try(:is_approved)
  end

  def group_invite_id
    GroupInvite.select(:id).where(user_id: scope.id, group_id: object.id).first.try(:id)
  end

  def create_post
    object.allow_post_creation?(scope)
  end

  def group_invites
    invites = []
    if object.group_owner?(scope)
      invites = object.pending_group_invites
    end

    invites
  end

  def group_requests
    requests = []
    if object.group_owner?(scope)
      requests = object.pending_group_requests
    end

    requests
  end

  def leave_group
    return false if object.group_owner?(scope)
    AppSettings::Value.new(:group_leaves, user: scope, group: object).on?
  end

  def group_sponsors
    object.sponsors
  end

  def group_members
    return [] unless object.show_member_list?(scope)
    object.filtered_group_members
  end

end
