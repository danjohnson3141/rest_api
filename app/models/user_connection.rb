class UserConnection < ActiveRecord::Base
  include User::Associations
  belongs_to :sender_user, :class_name => 'User', :foreign_key => 'sender_user_id'
  belongs_to :recipient_user, :class_name => 'User', :foreign_key => 'recipient_user_id'
  has_many :notifications, dependent: :delete_all
  validates :sender_user_id, presence: true, uniqueness: { scope: :recipient_user_id }
  validates :recipient_user_id, presence: true
  scope :approved, -> { where(is_approved: true) }
  scope :pending, -> { where(is_approved: false) }
  default_scope { order('created_at DESC') }

  after_save :notify_recipient

  def approve
    self.update_columns(is_approved: true)
    notify_sender
  end

  def notify_sender
    return if !sender_user.notifications?
    body = "#{recipient_user.full_name} has accepted your connection."
    Notification.create(notification_user: recipient_user, body: body, user: sender_user, user_connection: self)
  end

  def notify_recipient
    return if !recipient_user.notifications? || is_approved
    body = "#{sender_user.full_name} wants to connect with you."
    Notification.create(notification_user: sender_user,body: body, user: recipient_user, user_connection: self)
  end

  def is_approver?(user)
    recipient_user == user
  end

end
