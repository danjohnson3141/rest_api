class GroupType < ActiveRecord::Base
  include User::Associations

  def self.secret
    GroupType.where(is_group_visible: false).
    where(is_memberlist_visible: false).
    where(is_content_visible: false).
    where(is_approval_required: true)
  end

  def self.private
    GroupType.where(is_group_visible: true).
    where(is_memberlist_visible: false).
    where(is_content_visible: false).
    where(is_approval_required: true)
  end

  def self.open
    GroupType.where(is_group_visible: true).
    where(is_memberlist_visible: true).
    where(is_content_visible: true).
    where(is_approval_required: false)
  end

end
