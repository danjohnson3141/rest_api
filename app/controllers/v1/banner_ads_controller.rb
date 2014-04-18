module V1
  class BannerAdsController < ApplicationController
    # GET /banner_ads
    def index
      @banner_ads = BannerAd.all

      render json: @banner_ads
    end

    # GET /banner_ads/events/:id
    def event
      event = Event.find(params[:id])
      @banner_ads = BannerAd.joins(:sponsor).where(sponsors: {event_id: event.id})

      render json: @banner_ads
    end

    # GET /banner_ads/groups/:id
    def group
      group = Group.find(params[:id])
      @banner_ads = BannerAd.joins(:sponsor).where(sponsors: {group_id: group.id})

      render json: @banner_ads
    end

    # GET /banner_ads/sponsor/:id
    def sponsor
      @banner_ads = BannerAd.where(sponsor_id: params[:id])

      render json: @banner_ads
    end

  end
end
