class EventRegistrationStatusesController < ApplicationController
  # GET /event_registration_statuses
  # GET /event_registration_statuses.json
  def index
    @event_registration_statuses = EventRegistrationStatus.all

    render json: @event_registration_statuses
  end

  # GET /event_registration_statuses/1
  # GET /event_registration_statuses/1.json
  def show
    @event_registration_status = EventRegistrationStatus.find(params[:id])

    render json: @event_registration_status
  end

  # POST /event_registration_statuses
  # POST /event_registration_statuses.json
  def create
    @event_registration_status = EventRegistrationStatus.new(params[:event_registration_status])

    if @event_registration_status.save
      render json: @event_registration_status, status: :created, location: @event_registration_status
    else
      render json: @event_registration_status.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /event_registration_statuses/1
  # PATCH/PUT /event_registration_statuses/1.json
  def update
    @event_registration_status = EventRegistrationStatus.find(params[:id])

    if @event_registration_status.update(params[:event_registration_status])
      head :no_content
    else
      render json: @event_registration_status.errors, status: :unprocessable_entity
    end
  end

  # DELETE /event_registration_statuses/1
  # DELETE /event_registration_statuses/1.json
  def destroy
    @event_registration_status = EventRegistrationStatus.find(params[:id])
    @event_registration_status.destroy

    head :no_content
  end
end
