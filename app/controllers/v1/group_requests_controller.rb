module V1
  class GroupRequestsController < ApplicationController

    before_action :set_group_request, only: [:destroy, :update]

    # POST /group_requests
    def create
      @group_request = GroupRequest.new(group_request_params)
      if @group_request.save
        render json: @group_request, status: :created
      else
        render json: @group_request.errors, status: :unprocessable_entity
      end
    end

     # PUT/PATCH /group_requests/:id
     def update
       if @group_request.group.owner == current_user
         if @group_request.approve
           head :no_content
         end
       else
         head :forbidden
       end
     end

    # DELETE /group_requests/:group_requests_id
    def destroy
      raise ApiAccessEvanta::PermissionDenied if !current_user.allowed_to?(action: :destroy, object: @group_request)
      @group_request.destroy
      head :no_content
    end

    # GET /group_requests/groups
    def groups
      @group_requests = current_user.group_requests.not_approved
      render json: @group_requests, each_serializer: GroupRequestGroupSerializer
    end

    # GET /group_requests/users/:group_id
    def users
      group = Group.find(params[:group_id])
      if group.owner_user_id == current_user.id
        @group_requests = GroupRequest.where(group: group).order(:created_at).not_approved
        render json: @group_requests, each_serializer: GroupRequestUserSerializer
      else
        if current_user.group_member?(group) || !group.secret?
          head :forbidden
        else
          head :not_found
        end
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_group_request
        @group_request = GroupRequest.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def group_request_params
        params.require(:group_request).permit(:group_id, :user_id)
      end
  end
end
