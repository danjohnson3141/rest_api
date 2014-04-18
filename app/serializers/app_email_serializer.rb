class AppEmailSerializer < ActiveModel::Serializer
  attributes :id, :email_from, :email_subject, :email_body
end
