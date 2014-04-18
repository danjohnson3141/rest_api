class GroupWithMembership

  attr_reader :group

  def initialize(params, user)

    raise ApiAccessEvanta::PermissionDenied if AppSettings::Value.new(:group_creation, user: user).off?

    @params = params
    @user = user
    @errors = nil
  end

  def save
    @group = create_group    
    return false if !@group.save

    @group_member = create_membership
    return false if !@group_member.save

    true
  end

  def errors
    return @group.errors if !@group.errors.empty?
    return @group_member.errors if !@group_member.errors.empty?
  end


  private

    def create_group
      Group.new(@params)
    end

    def create_membership
      GroupMember.new(group_id: @group.id, user_id: @group.owner_user_id)
    end



end