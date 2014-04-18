class Sponsor < ActiveRecord::Base
  include User::Associations
  belongs_to :sponsor_type
  belongs_to :group
  belongs_to :event
  has_many :sponsor_users
  has_many :posts
  has_many :banner_ads
  has_many :sponsor_attachments
  has_many :sponsor_contact_users, through: :sponsor_users, source: :user

  validates :name, uniqueness: {case_sensitive: false}, presence: true, length: { maximum: 50 }
  validates :description, presence: true, length: { maximum: 500 }
  validates :sponsor_type_id, presence: true

  def self.group_sponsors_without_secret_group_sponsors
    Sponsor.joins("LEFT JOIN groups ON groups.id = sponsors.group_id").
    where("`groups`.`group_type_id` IS NULL OR `groups`.`group_type_id` IN (?)", (GroupType.open.map(&:id) + GroupType.private.map(&:id))).where(event_id: nil).where('group_id IS NOT NULL')
  end

  def event_note(user)
    EventNote.where(creator: user, sponsor: self)
  end

  def event_bookmark(user)
    EventBookmark.where(creator: user, sponsor: self)
  end

  def sponsor_users_excluding_hidden
    self.sponsor_contact_users.order(:last_name, :first_name).select { |sponsor_user| AppSettings::Value.new(:show_me_on_lists, user: sponsor_user).on? }
  end
end
