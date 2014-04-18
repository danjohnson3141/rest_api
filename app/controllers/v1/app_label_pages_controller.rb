module V1
  class AppLabelPagesController < ApplicationController

    skip_before_filter :authenticate_user_from_token!, :only => :show

    # GET /app/labels/:page
    def show
      @app_label_page = AppLabelPage.find_by_name(params[:page])
      if @app_label_page
        if @app_label_page.require_auth?
          authenticate_user_from_token!
        end
        render json: @app_label_page.app_labels
      else
        head :not_found
      end
    end

  end
end