class UserTinySerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :title, :organization_name, :photo, :moderator, :user_profile?

  def id
    return object.user_id if [EventSpeaker, PostContributor].include?(object.class)
    object.id
  end

  def moderator
    return object.try(:moderator) unless object.try(:moderator).nil?
    false
  end

  def user_profile?
    return User.find(id).user_profile? if [EventSpeaker, PostContributor].include?(object.class)
    object.user_profile?
  end

end
