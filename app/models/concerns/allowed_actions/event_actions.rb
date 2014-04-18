class AllowedActions::EventActions < AllowedActions

  def view
    (@user.viewable_groups.map(&:id).include?(@object.group_id) || @user.user_events.map(&:id).include?(@object.id)) && @user.events_section?    
  end

end