module V1
  class AppSupportsController < ApplicationController
    
    skip_before_filter :authenticate_user_from_token!, :only => :create

    # POST /app_supports
    def create
      @app_support = AppSupport.new(app_support_params)
      
      authenticate_user_if_token

      if current_user.present?
        @app_support.creator = current_user
        @app_support.updator = current_user
        @app_support.email = current_user.email
      end

      if @app_support.save
        render json: @app_support, status: :created
      else
        render json: @app_support.errors, status: :unprocessable_entity
      end
    end

  private
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def app_support_params
      params.require(:app_support).permit(:body, :email)
    end
  end
end