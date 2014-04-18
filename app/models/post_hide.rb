class PostHide < ActiveRecord::Base
  include User::Associations
  belongs_to :user
  belongs_to :post
end
