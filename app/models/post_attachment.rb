class PostAttachment < ActiveRecord::Base
  include User::Associations
  include TimeAgo
  
  validates :url, presence: true
  validates :post_id, presence: true

  belongs_to :post

  def post_action_message
    "added attachment"
  end

end
