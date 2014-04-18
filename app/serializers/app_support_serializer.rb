class AppSupportSerializer < ActiveModel::Serializer
  attributes :id, :body, :email, :created_by_user

  def created_by_user
    object.creator.full_name if object.created_by.present?
  end
end
