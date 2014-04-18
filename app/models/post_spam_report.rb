class PostSpamReport < ActiveRecord::Base
  include User::Associations
  belongs_to :user
  belongs_to :post
  belongs_to :post_comment
end
