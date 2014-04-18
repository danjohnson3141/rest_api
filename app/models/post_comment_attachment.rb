class PostCommentAttachment < ActiveRecord::Base
  include User::Associations
  belongs_to :post_comment
end
