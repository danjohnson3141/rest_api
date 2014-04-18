class UserRolesController < ApplicationController
  # GET /user_roles
  # GET /user_roles.json
  def index
    @user_roles = UserRole.all

    render json: @user_roles
  end

  # GET /user_roles/1
  # GET /user_roles/1.json
  def show
    @user_role = UserRole.find(params[:id])

    render json: @user_role
  end

  # POST /user_roles
  # POST /user_roles.json
  def create
    @user_role = UserRole.new(params[:user_role])

    if @user_role.save
      render json: @user_role, status: :created, location: @user_role
    else
      render json: @user_role.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /user_roles/1
  # PATCH/PUT /user_roles/1.json
  def update
    @user_role = UserRole.find(params[:id])

    if @user_role.update(params[:user_role])
      head :no_content
    else
      render json: @user_role.errors, status: :unprocessable_entity
    end
  end

  # DELETE /user_roles/1
  # DELETE /user_roles/1.json
  def destroy
    @user_role = UserRole.find(params[:id])
    @user_role.destroy

    head :no_content
  end
end
