module V1
  class GroupsController < ApplicationController

    before_action :set_group, only: [:show, :update]
    before_action :check_update_permissions, only: [:update]

    # GET /groups
    def index
      @groups = Group.filtered_list(current_user)
      render json: @groups
    end

    # GET /group/:id
    def show
      if @group.show_group?(current_user)
        render json: @group
      else
        head :not_found
      end
    end

    # POST /groups
    def create
      @group_with_membership = GroupWithMembership.new(post_group_params, current_user)
      if @group_with_membership.save
        render json: @group_with_membership.group, status: :created
      else
        render json: @group_with_membership.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /groups/:id
    def update
      if @group.update(patch_group_params)
        head :no_content
      else
        render json: @group.errors, status: :unprocessable_entity
      end
    end
    

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_group
        @group = Group.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def post_group_params
        params.require(:group).permit(:name, :description, :group_type_id).merge!({owner_user_id: current_user.id.to_s})
      end

      def patch_group_params
        params.require(:group).permit(:name, :description)
      end

      def check_update_permissions
        current_user.allowed_to_update_group?(@group)
      end

  end
end