module Query
  class GroupActivityFeed
    def initialize(group, relation = Post.unscoped)
      @group = group
      @relation = relation
      # query
    end

    # private
      def query
        @relation.includes([:post_likes, :post_comments, :post_attachments]).select("posts.*, GREATEST(posts.created_at, COALESCE(post_likes.created_at, 0), COALESCE(post_comments.created_at, 0), COALESCE(post_attachments.created_at, 0)) AS activity").
        joins("LEFT JOIN post_likes ON post_likes.post_id = posts.id").
        joins("LEFT JOIN post_comments ON post_comments.post_id = posts.id").
        joins("LEFT JOIN post_attachments ON post_attachments.post_id = posts.id").
        where(group: @group).group("posts.id").order("MAX(activity) DESC")
      end
  end
end