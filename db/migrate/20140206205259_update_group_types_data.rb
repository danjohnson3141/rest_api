class UpdateGroupTypesData < ActiveRecord::Migration
  def change
    
    return if Rails.env == "test"

    group_type = GroupType.find_by_id(1)
    if !group_type.nil?
      group_type.is_group_visible = 1
      group_type.is_memberlist_visible = 1
      group_type.is_content_visible = 1
      group_type.is_approval_required = 0
      group_type.save
    end

    group_type = GroupType.find_by_id(2)
    if !group_type.nil?
      group_type.is_group_visible = 1
      group_type.is_memberlist_visible = 0
      group_type.is_content_visible = 0
      group_type.is_approval_required = 1
      group_type.save
    end

    group_type = GroupType.find_by_id(3)
    if !group_type.nil?
      group_type.is_group_visible = 0
      group_type.is_memberlist_visible = 0
      group_type.is_content_visible = 0
      group_type.is_approval_required = 1
      group_type.save
    end
  end
end