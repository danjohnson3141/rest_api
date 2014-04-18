class PostContributor < ActiveRecord::Base
  include User::Associations
  belongs_to :user
  belongs_to :post
  validates :user_id, presence: true
  validates :post_id, presence: true, uniqueness: { scope: :user_id }
end
