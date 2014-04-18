module V1
  class UsersController < ApplicationController

    skip_before_filter :authenticate_user_from_token!, :only => :forgot_password
    before_action :set_user, only: [:show, :update, :post_options]

    # GET /users/settings
    def settings
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :view, object: current_user)
      render json: UserSettings.new(current_user).app_setting_options, each_serializer: AppSettingOptionUserSerializer, root: "app_setting_options"
    end

    # GET /users/profile
    def show
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :view, object: @user)      
      render json: @user
    end

    # GET /users/profile/:id
    def show_other_user
      @user = User.find(params[:id])
      raise ApiAccessEvanta::RecordOutOfScope unless AppSettings::Value.new(:user_profile, user: @user).on?
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :view, object: @user)
      render json: @user
    end

    # PATCH/PUT /users/profile
    def update
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :update, object: @user)
      if @user.update(user_params)
        head :no_content
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # GET /users/post_options
    def post_options
      render json: current_user, root: :user, serializer: UserPostOptionsSerializer
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = User.find(current_user.id)
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def user_params
        params.require(:user).permit(:alt_email, :first_name, :last_name, :title, :organization_name, :bio, :photo)
      end
  end
end
