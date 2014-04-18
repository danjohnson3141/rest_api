class MessageAttachment < ActiveRecord::Base
  include User::Associations
  belongs_to :message
end
