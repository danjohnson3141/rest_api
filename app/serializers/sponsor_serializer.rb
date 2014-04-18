class SponsorSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :logo, :url, :splash_sponsor, :event_note_id, :event_bookmark_id
  has_one :sponsor_type
  has_many :banner_ads, serializer: BannerAdShortSerializer
  # has_many :sponsor_users
  has_many :sponsor_contact_users, serializer: UserShortSerializer
  has_many :sponsor_attachments, serializer: SponsorAttachmentSerializer
  has_one :event, serializer: EventTinySerializer
  has_one :group, serializer: GroupTinySerializer

  def sponsor_contact_users
    object.sponsor_users_excluding_hidden
  end

  def event_note_id
    object.event_note(scope).first.try(:id)
  end

  def event_bookmark_id
    object.event_bookmark(scope).first.try(:id)
  end

end
