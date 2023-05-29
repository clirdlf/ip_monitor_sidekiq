# frozen_string_literal: true

##
# Grants Controller
class GrantsController < ApplicationController
  before_action :set_grant,  only: %i[show edit update destroy verify_resources]
  before_action :set_grants, only: %i[index stats]

  # GET /grants
  # GET /grants.json
  def index
    respond_to do |format|
      format.html
      format.csv { send_data @grants.to_csv, filename: "resource-status-#{Time.zone.today}.csv" }
    end
  end

  def stats
    @grants    = Grant.all
    @resources = Resource.all
    @statuses  = Status.all
  end

  def issues
    @statuses = Status.where(latest: true).where.not(status: 'OK')
  end

  # Verify for a specfic grant
  def verify_resources
    # @see https://andycroll.com/ruby/enqueue-jobs-quickly-with-sidekiq-bulk/

    # query only objects that are valid AND are not restricted
    @resources = @grant.resources.where('restricted is false and access_url LIKE \'http%\'')

    @resources.in_batches do |resource|
      array_of_args = resource.ids.map { |x| [x] }
      ResourceValidatorJob.perform_bulk(array_of_args)
    end
    # @grant.resources.each do |resource|
    #   next unless resource.valid_url?
    #   ResourceValidatorJob.perform_later(resource) unless resource.restricted?
    # end

    redirect_to @grant, notice: "#{@resources.size} resources successfully queued."
  end

  # GET /grants/1
  # GET /grants/1.json
  def show; end

  # GET /grants/new
  def new
    @grant = Grant.new
  end

  # GET /grants/1/edit
  def edit; end

  # POST /grants
  # POST /grants.json
  def create
    @grant = Grant.new(grant_params)

    respond_to do |format|
      if @grant.save
        format.html { redirect_to @grant, notice: 'Grant was successfully created.' }
        format.json { render :show, status: :created, location: @grant }
      else
        format.html { render :new }
        format.json { render json: @grant.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /grants/1
  # PATCH/PUT /grants/1.json
  def update
    respond_to do |format|
      if @grant.update(grant_params)
        format.html { redirect_to @grant, notice: 'Grant was successfully updated.' }
        format.json { render :show, status: :ok, location: @grant }
      else
        format.html { render :edit }
        format.json { render json: @grant.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /grants/1
  # DELETE /grants/1.json
  def destroy
    @grant.destroy
    respond_to do |format|
      format.html { redirect_to grants_url, notice: 'Grant was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_grant
    @grant = Grant.find(params[:id])
  end

  def set_grants
    @grants = Grant.all
  end

  # Only allow a list of trusted parameters through.
  def grant_params
    params.require(:grant).permit(
      :title, :institution, :grant_number, :contact, :email, :submission
    )
  end
end
