class Notification < ActiveRecord::Base
  include User::Associations
  include TimeAgo
  belongs_to :event
  belongs_to :group
  belongs_to :group_invite
  belongs_to :post
  belongs_to :user
  belongs_to :notification_user, :class_name => 'User', :foreign_key => 'notification_user_id'
  belongs_to :user_connection
  scope :unviewed, -> { where(is_viewed: false) }
  default_scope { order("created_at DESC") }

  validates :notification_user_id, presence: true

end
