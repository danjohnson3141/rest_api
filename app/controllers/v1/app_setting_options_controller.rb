module V1
  class AppSettingOptionsController < ApplicationController
    # GET /app_setting_options
    def index
      @app_setting_options = AppSettingOption.all
 
      render json: @app_setting_options
    end
 
    # GET /app_setting_options/1
    def show
      @app_setting_option = AppSettingOption.find(params[:id])
 
      render json: @app_setting_option
    end
 
    # POST /app_setting_options
    def create
      @app_setting_option = AppSettingOption.new(params[:app_setting_option])
 
      if @app_setting_option.save
        render json: @app_setting_option, status: :created, location: @app_setting_option
      else
        render json: @app_setting_option.errors, status: :unprocessable_entity
      end
    end
 
    # PATCH/PUT /app_setting_options/1
    def update
      @app_setting_option = AppSettingOption.find(params[:id])
 
      if @app_setting_option.update(params[:app_setting_option])
        head :no_content
      else
        render json: @app_setting_option.errors, status: :unprocessable_entity
      end
    end
 
    # DELETE /app_setting_options/1
    def destroy
      @app_setting_option = AppSettingOption.find(params[:id])
      @app_setting_option.destroy
 
      head :no_content
    end
  end
end