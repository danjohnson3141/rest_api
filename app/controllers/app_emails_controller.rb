class AppEmailsController < ApplicationController
  # GET /app_emails
  # GET /app_emails.json
  def index
    @app_emails = AppEmail.all

    render json: @app_emails
  end

  # GET /app_emails/1
  # GET /app_emails/1.json
  def show
    @app_email = AppEmail.find(params[:id])

    render json: @app_email
  end

  # POST /app_emails
  # POST /app_emails.json
  def create
    @app_email = AppEmail.new(params[:app_email])

    if @app_email.save
      render json: @app_email, status: :created, location: @app_email
    else
      render json: @app_email.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /app_emails/1
  # PATCH/PUT /app_emails/1.json
  def update
    @app_email = AppEmail.find(params[:id])

    if @app_email.update(params[:app_email])
      head :no_content
    else
      render json: @app_email.errors, status: :unprocessable_entity
    end
  end

  # DELETE /app_emails/1
  # DELETE /app_emails/1.json
  def destroy
    @app_email = AppEmail.find(params[:id])
    @app_email.destroy

    head :no_content
  end
end
