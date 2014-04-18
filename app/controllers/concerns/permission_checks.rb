module PermissionChecks
  extend ActiveSupport::Concern

  # This one is a little odd but yes we want to not allow someone to view your posts if you have disabled post counts
  def view_another_users_post_list
    raise ApiAccessEvanta::PermissionDenied if !@user.show_posts_count?
  end

  def view_profiles
    raise ApiAccessEvanta::PermissionDenied if !current_user.view_profiles?
  end

  def member_or_open_group
    raise ApiAccessEvanta::PermissionDenied if !current_user.group_member?(@group) && !@group.group_type.is_content_visible?
  end

 
end