module V1
  class GroupMembersController < ApplicationController
 
    before_action :allow_groups
    before_action :set_group_member, only: [:destroy]
 
    # POST /group_members
    def create
      @group_member = GroupMember.new(group_member_params)
      @group_member.check_permission
      
      if @group_member.save
        render json: @group_member, status: :created
      else
        render json: @group_member.errors, status: :unprocessable_entity
      end

    end
 
    # DELETE /group_members/:group_member_id
    def destroy
      raise ApiAccessEvanta::PermissionDenied unless AppSettings::Value.new(:group_leaves, user: @group_member.user, group: @group_member.group).on?
      if @group_member
        if Group.find_by_id(@group_member.group_id).owner_user_id != current_user.id && @group_member.user_id == current_user.id
          @group_member.destroy
          head :no_content
        else
          head :forbidden
        end
      else
        head :not_found
      end
    end
 
    # GET /group_members/groups/:user_id
    def groups
      if User.find_by_id(params[:user_id])
        @group_members = GroupMember.where(user_id: params[:user_id]).includes(:group)
        render json: @group_members, each_serializer: GroupMemberGroupSerializer
      else
        head :not_found
      end
    end
 
    # GET /group_members/users/:group_id
    def users
      @group = Group.find(params[:group_id])
      if @group.show_member_list?(current_user)
        render json: @group.filtered_group_members, each_serializer: GroupMemberUserSerializer
      else
        head :forbidden
      end
    end
    

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_group_member
        @group_member = GroupMember.find(params[:group_member_id])
      end
 
      # Never trust parameters from the scary internet, only allow the white list through.
      def group_member_params
        params.require(:group_member).permit(:group_id).merge!({"user_id" => current_user.id})
      end

       def allow_groups
        raise ApiAccessEvanta::PermissionDenied unless AppSettings::Value.new(:groups).on?
      end
 
  end
end