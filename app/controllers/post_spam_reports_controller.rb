class PostSpamReportsController < ApplicationController
  # GET /post_spam_reports
  # GET /post_spam_reports.json
  def index
    @post_spam_reports = PostSpamReport.all

    render json: @post_spam_reports
  end

  # GET /post_spam_reports/1
  # GET /post_spam_reports/1.json
  def show
    @post_spam_report = PostSpamReport.find(params[:id])

    render json: @post_spam_report
  end

  # POST /post_spam_reports
  # POST /post_spam_reports.json
  def create
    @post_spam_report = PostSpamReport.new(params[:post_spam_report])

    if @post_spam_report.save
      render json: @post_spam_report, status: :created, location: @post_spam_report
    else
      render json: @post_spam_report.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /post_spam_reports/1
  # PATCH/PUT /post_spam_reports/1.json
  def update
    @post_spam_report = PostSpamReport.find(params[:id])

    if @post_spam_report.update(params[:post_spam_report])
      head :no_content
    else
      render json: @post_spam_report.errors, status: :unprocessable_entity
    end
  end

  # DELETE /post_spam_reports/1
  # DELETE /post_spam_reports/1.json
  def destroy
    @post_spam_report = PostSpamReport.find(params[:id])
    @post_spam_report.destroy

    head :no_content
  end
end
