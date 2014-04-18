module V1
  class AppSettingsController < ApplicationController
    include ObjectSetters

    before_action only: [:destroy] { set_object(AppSetting) }
    skip_before_filter :authenticate_user_from_token!, :only => :show

    # Big Kahuna
    # GET /app_settings/?names[]=support_link
    def show
      authenticate_user_if_token

      group = nil
      event = nil

      return head :no_content if params[:names].nil? || params[:names].empty? || params[:names].class != Array

      if params[:event_id]
        event = Event.find(params[:event_id])
      end

      if params[:group_id]
        group = Group.find(params[:group_id])
      end

      app_settings = {}

      params[:names].each do |name|
        app_settings[name.to_sym] = AppSettings::Value.new(name.to_sym, user: current_user, group: group, event: event).on?
      end
      render json: app_settings
    end

    # POST /app_settings
    def create
      # binding.pry
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :view, object: current_user)
      @app_setting = AppSetting.new(post_params)
      raise ApiAccessEvanta::Unprocessable unless AppSettingOption.find_by_id(@app_setting.app_setting_option_id).present?
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :create, object: @app_setting)

      if @app_setting.save
        render json: @app_setting, status: :created
      else
        render json: @app_setting.errors, status: :unprocessable_entity
      end

    end

    # DELETE /app_settings/1
    def destroy
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :view, object: current_user)
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :destroy, object: @app_setting)
      @app_setting.destroy
      head :no_content
    end

    private
      # Never trust parameters from the scary internet, only allow the white list through.
      def post_params
        params.require(:app_setting).permit(:app_setting_option_id).
        merge!({"user_id" => current_user.id, "created_by" => current_user.id, "updated_by" => current_user.id})
      end

  end
end