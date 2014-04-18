class PostHidesController < ApplicationController
  # GET /post_hides
  # GET /post_hides.json
  def index
    @post_hides = PostHide.all

    render json: @post_hides
  end

  # GET /post_hides/1
  # GET /post_hides/1.json
  def show
    @post_hide = PostHide.find(params[:id])

    render json: @post_hide
  end

  # POST /post_hides
  # POST /post_hides.json
  def create
    @post_hide = PostHide.new(params[:post_hide])

    if @post_hide.save
      render json: @post_hide, status: :created, location: @post_hide
    else
      render json: @post_hide.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /post_hides/1
  # PATCH/PUT /post_hides/1.json
  def update
    @post_hide = PostHide.find(params[:id])

    if @post_hide.update(params[:post_hide])
      head :no_content
    else
      render json: @post_hide.errors, status: :unprocessable_entity
    end
  end

  # DELETE /post_hides/1
  # DELETE /post_hides/1.json
  def destroy
    @post_hide = PostHide.find(params[:id])
    @post_hide.destroy

    head :no_content
  end
end
