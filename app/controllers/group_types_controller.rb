class GroupTypesController < ApplicationController
  # GET /group_types
  # GET /group_types.json
  def index
    @group_types = GroupType.all

    render json: @group_types
  end

  # GET /group_types/1
  # GET /group_types/1.json
  def show
    @group_type = GroupType.find(params[:id])

    render json: @group_type
  end

  # POST /group_types
  # POST /group_types.json
  def create
    @group_type = GroupType.new(params[:group_type])

    if @group_type.save
      render json: @group_type, status: :created, location: @group_type
    else
      render json: @group_type.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /group_types/1
  # PATCH/PUT /group_types/1.json
  def update
    @group_type = GroupType.find(params[:id])

    if @group_type.update(params[:group_type])
      head :no_content
    else
      render json: @group_type.errors, status: :unprocessable_entity
    end
  end

  # DELETE /group_types/1
  # DELETE /group_types/1.json
  def destroy
    @group_type = GroupType.find(params[:id])
    @group_type.destroy

    head :no_content
  end
end
