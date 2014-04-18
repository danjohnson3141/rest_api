class FeaturedPost < ActiveRecord::Base
  include User::Associations 
  belongs_to :post
  validates :post_id, presence: true, uniqueness: true
  default_scope { order("created_at DESC") }
end
