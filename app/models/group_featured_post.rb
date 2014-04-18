class GroupFeaturedPost < ActiveRecord::Base
  include User::Associations
  belongs_to :post
  belongs_to :group
end
