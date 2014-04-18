class EventShortSerializer < ActiveModel::Serializer

  def event_follower_id
    EventFollower.where(user_id: current_user.id, event_id: self.id).first.try(:id)
  end

  attributes :id, :name, :begin_date, :end_date, :venue_name, :address, :state, :postal_code, :event_follower_id
  has_one :country, serializer: CountryShortSerializer
  has_one :group, serializer: GroupShortSerializer
end
