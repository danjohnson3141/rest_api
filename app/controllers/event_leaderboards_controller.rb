class EventLeaderboardsController < ApplicationController
  # GET /event_leaderboards
  # GET /event_leaderboards.json
  def index
    @event_leaderboards = EventLeaderboard.all

    render json: @event_leaderboards
  end

  # GET /event_leaderboards/1
  # GET /event_leaderboards/1.json
  def show
    @event_leaderboard = EventLeaderboard.find(params[:id])

    render json: @event_leaderboard
  end

  # POST /event_leaderboards
  # POST /event_leaderboards.json
  def create
    @event_leaderboard = EventLeaderboard.new(params[:event_leaderboard])

    if @event_leaderboard.save
      render json: @event_leaderboard, status: :created, location: @event_leaderboard
    else
      render json: @event_leaderboard.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /event_leaderboards/1
  # PATCH/PUT /event_leaderboards/1.json
  def update
    @event_leaderboard = EventLeaderboard.find(params[:id])

    if @event_leaderboard.update(params[:event_leaderboard])
      head :no_content
    else
      render json: @event_leaderboard.errors, status: :unprocessable_entity
    end
  end

  # DELETE /event_leaderboards/1
  # DELETE /event_leaderboards/1.json
  def destroy
    @event_leaderboard = EventLeaderboard.find(params[:id])
    @event_leaderboard.destroy

    head :no_content
  end
end
