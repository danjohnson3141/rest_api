module V1
  class SponsorsController < ApplicationController
    # GET /sponsors
    def index
      render json: Sponsor.all.includes(:sponsor_type).order("sponsor_types.display_rank", :name)
    end

    # GET /sponsors/app
    def app
      render json: Sponsor.includes([:banner_ads, :sponsor_type]).where(event_id: nil, group_id: nil).order("sponsor_types.display_rank", :name)
    end

    # GET /sponsors/group
    def group
      render json: Sponsor.includes([:banner_ads, :sponsor_type]).order("sponsor_types.display_rank", :name).group_sponsors_without_secret_group_sponsors
    end

    # GET /sponsors/event
    def event
      render json: Sponsor.includes([:banner_ads, :sponsor_type]).where(group_id: nil).where('event_id IS NOT NULL').order("sponsor_types.display_rank", :name)
    end

    # GET /sponsors/:id
    def show
      @sponsor = Sponsor.find(params[:id])
      check_permission
      render json: @sponsor
    end

  private
    def check_permission
      if @sponsor.event.present?
        raise ApiAccessEvanta::PermissionDenied if !@sponsor.event.show_event_sponsors?(current_user)
        raise ActiveRecord::RecordNotFound if !@sponsor.event.group.open? && !current_user.group_member?(@sponsor.event.group)
      end
      if @sponsor.group.present?
        raise ActiveRecord::RecordNotFound if !@sponsor.group.open? && !current_user.group_member?(@sponsor.group)
      end
      if @sponsor.group.nil? && @sponsor.group.nil?
        raise ApiAccessEvanta::PermissionDenied if !AppSettings::Value.new(:app_sponsors).on?
      end
    end

  end
end
