module V1
  class EventsController < ApplicationController
    include ObjectSetters

    before_action :set_user, only: [:all, :past, :upcoming]
    before_action :permission_check, only: [:show, :all, :past, :upcoming]
    before_action only: [:show] { set_object(Event) }
    after_action only: [:index] { set_pagination_headers(:events) }

    # GET /events
    # def index
    #   @events = Event.all.order(:begin_date).paginate(per_page: params[:per_page], page: params[:page])
    #   render json: @events
    # end

    # GET /events/:id
    def show
      # @event = Event.find(params[:id])
      raise ApiAccessEvanta::RecordOutOfScope unless current_user.allowed_to?(action: :view, object: @event)
      render json: @event
    end

    # GET /events/all
    def all
      render json: current_user.my_events
    end

    # GET /events/past
    def past
        render json: current_user.past_events
    end

    # GET /events/upcoming
    def upcoming
        render json: current_user.future_events
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_user
        @user = nil
        @user = User.find(params[:user_id]) if !params[:user_id].nil?
      end

      def permission_check
        raise ActiveRecord::RecordNotFound if !current_user.events_section?
      end

  end
end
