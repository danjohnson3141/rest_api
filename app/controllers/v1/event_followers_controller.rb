module V1
  class EventFollowersController < ApplicationController

    before_action :set_event_follower, only: [:destroy]
    before_action :allow_event_following

    # POST /event_followers
    def create

      @event_follower = EventFollower.new(event_follower_params)

      if @event_follower.save
        render json: @event_follower, status: :created
      else
        render json: @event_follower.errors, status: :unprocessable_entity
      end
    end

    # DELETE /event_followers/1
    def destroy
      if current_user.allowed_to?(action: :destroy, object: @event_follower)
        @event_follower.destroy
        head :no_content
      else
        head :forbidden
      end
    end

    # GET /event_followers/events/:user_id
    def events
      if User.find_by_id(params[:user_id])
        @event_followers = EventFollower.where(user_id: params[:user_id])
        render json: @event_followers, each_serializer: EventFollowerUserSerializer
      else
        head :not_found
      end
    end

    # GET /event_followers/users/:event_id
    def users
      if Event.find_by_id(params[:event_id])
        @event_followers = EventFollower.where(event_id: params[:event_id])
        render json: @event_followers, each_serializer: EventFollowerEventSerializer
      else
        head :not_found
      end
    end


    private
      # Use callbacks to share common setup or constraints between actions.
      def set_event_follower
        @event_follower = EventFollower.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def event_follower_params
        params.require(:event_follower).permit(:event_id).
        merge!({"user_id" => current_user.id, "created_by" => current_user.id, "updated_by" => current_user.id})
      end

      def allow_event_following
        raise ApiAccessEvanta::PermissionDenied if AppSettings::Value.new(:event_follows).off?
      end
  end
end