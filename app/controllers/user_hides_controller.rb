class UserHidesController < ApplicationController
  # GET /user_hides
  # GET /user_hides.json
  def index
    @user_hides = UserHide.all

    render json: @user_hides
  end

  # GET /user_hides/1
  # GET /user_hides/1.json
  def show
    @user_hide = UserHide.find(params[:id])

    render json: @user_hide
  end

  # POST /user_hides
  # POST /user_hides.json
  def create
    @user_hide = UserHide.new(params[:user_hide])

    if @user_hide.save
      render json: @user_hide, status: :created, location: @user_hide
    else
      render json: @user_hide.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_hides/1
  # PATCH/PUT /user_hides/1.json
  def update
    @user_hide = UserHide.find(params[:id])

    if @user_hide.update(params[:user_hide])
      head :no_content
    else
      render json: @user_hide.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_hides/1
  # DELETE /user_hides/1.json
  def destroy
    @user_hide = UserHide.find(params[:id])
    @user_hide.destroy

    head :no_content
  end
end
