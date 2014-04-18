class EventLeaderboardOptionsController < ApplicationController
  # GET /event_leaderboard_options
  # GET /event_leaderboard_options.json
  def index
    @event_leaderboard_options = EventLeaderboardOption.all

    render json: @event_leaderboard_options
  end

  # GET /event_leaderboard_options/1
  # GET /event_leaderboard_options/1.json
  def show
    @event_leaderboard_option = EventLeaderboardOption.find(params[:id])

    render json: @event_leaderboard_option
  end

  # POST /event_leaderboard_options
  # POST /event_leaderboard_options.json
  def create
    @event_leaderboard_option = EventLeaderboardOption.new(params[:event_leaderboard_option])

    if @event_leaderboard_option.save
      render json: @event_leaderboard_option, status: :created, location: @event_leaderboard_option
    else
      render json: @event_leaderboard_option.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /event_leaderboard_options/1
  # PATCH/PUT /event_leaderboard_options/1.json
  def update
    @event_leaderboard_option = EventLeaderboardOption.find(params[:id])

    if @event_leaderboard_option.update(params[:event_leaderboard_option])
      head :no_content
    else
      render json: @event_leaderboard_option.errors, status: :unprocessable_entity
    end
  end

  # DELETE /event_leaderboard_options/1
  # DELETE /event_leaderboard_options/1.json
  def destroy
    @event_leaderboard_option = EventLeaderboardOption.find(params[:id])
    @event_leaderboard_option.destroy

    head :no_content
  end
end
