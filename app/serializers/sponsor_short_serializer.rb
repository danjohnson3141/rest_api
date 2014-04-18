class SponsorShortSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :logo, :url, :event_note_id, :event_bookmark_id
  has_one :sponsor_type
  has_many :banner_ads, serializer: BannerAdShortSerializer

  def event_note_id
    object.event_note(scope).first.try(:id)
  end

  def event_bookmark_id
    object.event_bookmark(scope).first.try(:id)
  end

end
