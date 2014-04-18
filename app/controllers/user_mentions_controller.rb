class UserMentionsController < ApplicationController
  # GET /user_mentions
  # GET /user_mentions.json
  def index
    @user_mentions = UserMention.all

    render json: @user_mentions
  end

  # GET /user_mentions/1
  # GET /user_mentions/1.json
  def show
    @user_mention = UserMention.find(params[:id])

    render json: @user_mention
  end

  # POST /user_mentions
  # POST /user_mentions.json
  def create
    @user_mention = UserMention.new(params[:user_mention])

    if @user_mention.save
      render json: @user_mention, status: :created, location: @user_mention
    else
      render json: @user_mention.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_mentions/1
  # PATCH/PUT /user_mentions/1.json
  def update
    @user_mention = UserMention.find(params[:id])

    if @user_mention.update(params[:user_mention])
      head :no_content
    else
      render json: @user_mention.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_mentions/1
  # DELETE /user_mentions/1.json
  def destroy
    @user_mention = UserMention.find(params[:id])
    @user_mention.destroy

    head :no_content
  end
end
