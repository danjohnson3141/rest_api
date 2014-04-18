module V1
  class CountriesController < ApplicationController
    
    # GET /countries
    def index
      @countries = Country.all

      render json: @countries
    end

    # GET /countries/1
    def show
      @country = Country.find(params[:id])

      render json: @country
    end

    # POST /countries
    def create
      @country = Country.new(params[:country])

      if @country.save
        render json: @country, status: :created, location: @country
      else
        render json: @country.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /countries/1
    def update
      @country = Country.find(params[:id])

      if @country.update(params[:country])
        head :no_content
      else
        render json: @country.errors, status: :unprocessable_entity
      end
    end

    # DELETE /countries/1
    def destroy
      @country = Country.find(params[:id])
      @country.destroy

      head :no_content
    end
  end
end
