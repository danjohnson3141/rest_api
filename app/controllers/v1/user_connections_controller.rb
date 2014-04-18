module V1
  class UserConnectionsController < ApplicationController

    before_action :set_user_connection, only: [:destroy, :update]
    before_action :check_permissions, only: [:pending, :create]

    # POST /user_connections
    def create
      recipient = User.find(user_connection_params['recipient_user_id'])
      if current_user != recipient
        @user_connection = UserConnection.new(user_connection_params)
        if @user_connection.save
          render json: @user_connection, status: :created
        else
          render json: @user_connection.errors, status: :unprocessable_entity
        end
      else
        head :forbidden
      end
    end

    # PUT/PATCH /user_connections/:id
    def update
      if @user_connection.recipient_user_id == current_user.id
        if @user_connection.approve
          head :no_content
        end
      else
        head :forbidden
      end
    end

    # DELETE /user_connections/:id
    def destroy
      if ((@user_connection.sender_user_id == current_user.id || @user_connection.recipient_user_id == current_user.id) && @user_connection.is_approved) ||
        (@user_connection.recipient_user_id == current_user.id && !@user_connection.is_approved)
        @user_connection.destroy
        head :no_content
      else
        head :forbidden
      end
    end

    # GET /user_connections/user/:user_id
    def user
      @user = User.find(params[:user_id])
      check_viewing_permission(@user) if viewing_another_user?(@user)
      render json: @user.users_connected_to, each_serializer: UserShortSerializer, root: 'users'
    end

    # GET user_connections/pending
    def pending
      render json: current_user.users_pending_connection, each_serializer: UserShortSerializer, root: 'users'
    end

    private
      def check_permissions
        raise ApiAccessEvanta::PermissionDenied if !current_user.user_connections_enabled?
      end
      def check_viewing_permission(user)
        raise ApiAccessEvanta::PermissionDenied if !user.view_my_connections_enabled?
      end
      # Use callbacks to share common setup or constraints between actions.
      def set_user_connection
        @user_connection = UserConnection.find(params[:id])
      end

      def viewing_another_user?(user)
        return false if current_user == user
        raise ApiAccessEvanta::PermissionDenied if !current_user.view_profiles?
        true
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def user_connection_params
        params.require(:user_connection).permit(:recipient_user_id).
        merge!({"sender_user_id" => current_user.id, "created_by" => current_user.id, "updated_by" => current_user.id})
      end
  end
end
