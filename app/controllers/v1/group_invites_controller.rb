module V1
  class GroupInvitesController < ApplicationController

    before_action :set_group_invite, only: [:destroy]

    # POST /group_invites
    def create
      GroupInvite.check_write_permission(current_user, group_invite_params)
      @group_invite = GroupInvite.new(group_invite_params)

      if @group_invite.save
        render json: @group_invite, status: :created
      else
        render json: @group_invite.errors, status: :unprocessable_entity
      end
    end

    # DELETE /group_invites/:id
    def destroy
      if @group_invite
        if @group_invite.user_id == current_user.id
          @group_invite.destroy
          head :no_content
        else
          head :forbidden
        end
      else
        head :not_found
      end
    end

    # GET /group_invites/user_search/:group_id
    def user_search
      users = User.group_invite_search(query: params[:query], group: Group.find(params[:group_id]))

      if users.present?
        render json: users, root: 'users', each_serializer: UserNanoSerializer
      else
        head :not_found
      end

    end

    # GET /group_invites/groups
    def groups
      @group_invites = current_user.group_invites.includes(:group).order('groups.name').
      joins("LEFT JOIN group_members on group_members.group_id = group_invites.group_id AND group_members.user_id = group_invites.user_id").where("group_members.id IS NULL")
      render json: @group_invites, each_serializer: GroupInviteGroupSerializer
    end

    # GET /group_invites/users/:group_id
    def users
      GroupInvite.check_read_permission(params[:group_id], current_user)
      @group_invites = GroupInvite.includes(:user).order("users.last_name, users.first_name").
      joins("LEFT JOIN group_members on group_members.group_id = group_invites.group_id AND group_members.user_id = group_invites.user_id").
      where(group_id: params['group_id']).where("group_members.id IS NULL")

      render json: @group_invites, each_serializer: GroupInviteUserSerializer
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_group_invite
        @group_invite = GroupInvite.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def group_invite_params
        params.require(:group_invite).permit(:group_id, :user_id)
      end
  end
end
