module V1
  class NavigationController < ApplicationController
    
    # GET /navigation/left
    def left
      render json: NavigationLeft.new(current_user), serializer: NavigationLeftSerializer
    end


    # GET /navigation/right
    def right
      event = Event.find(params[:event_id])
      render json: NavigationRight.new(current_user, event), serializer: NavigationRightSerializer
    end

  end
end