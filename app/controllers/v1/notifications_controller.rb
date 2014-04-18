module V1
  class NotificationsController < ApplicationController

    # GET /notifications/:id
    def show
      @notification = Notification.find(params[:id])

      render json: @notification
    end

    # GET /notifications/user/:user_id
    def user_notifications
      user = User.find(params[:user_id])
      raise ApiAccessEvanta::PermissionDenied if current_user != user
      notifications = user.notifications.unviewed
      render json: notifications
    end

    # PATCH/PUT /notifications/1
    def update
      @notification = Notification.find(params[:id])
      @notification.is_viewed = true

      if @notification.save
        head :no_content
      else
        render json: @notification.errors, status: :unprocessable_entity
      end
    end

  end
end
