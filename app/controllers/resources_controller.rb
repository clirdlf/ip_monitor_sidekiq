# frozen_string_literal: true

##
# Resources controller
class ResourcesController < ApplicationController
  before_action :set_grant, only: %i[edit status update destroy]
  before_action :set_resource, only: %i[show verify]

  def verify_all
    # TODO: filter only non-restricted resources
    # @resources = Resource.order(Arel.sql('RANDOM()')).where('statuses_count IS NULL')
    # WHERE restricted IS FALSE
    # AND access_url LIKE 'http%
    @resources = Resource.order(Arel.sql('RANDOM()')).where('restricted IS false AND access_url LIKE \'http%\' LIMIT 10')

      # TODO: DRY
    @resources.in_batches do |resource|
      array_of_args = resource.ids.map { |x| [x] }
      ResourceValidatorJob.perform_bulk(array_of_args) unless resource.restricted?
    end
    # @resources.each do |r|
    #   next unless r.valid_url?

    #   #  TODO: this check should be in the object.run_check
    #   ResourceValidatorJob.perform_later(r) unless r.restricted?
    # end
  end

  def verify_grant
    @resources = Resource.find(params[:grant_id])

    @resources.in_batches do | resource | 
      array_of_args = resource.ids.map { |x| [x] }
      ResourceValidatorJob.perform_bulk(array_of_args) unless resource.restricted?
    end

    # @resources.each do |resource|
    #   next unless resource.valid_url?

    #   ResourceValidatorJob.perform_later(resource) unless resource.restricted?
    # end

  end

  def verify_rar
    @resources = Resource.joins(:grant)
                         .where('program = \'Recordings at Risk\' AND restricted is false and access_url LIKE \'http%\'')
                         .order(Arel.sql('RANDOM()'))

    @resources.in_batches do |resource|
      array_of_args = resource.ids.map { |x| [x] }
      ResourceValidatorJob.perform_bulk(array_of_args) unless resource.restricted?
    end

    # @resources.each do |resource|
    #   next unless resource.valid_url?

    #   ResourceValidatorJob.perform_later(resource) unless r.restricted?
    # end
  end

  def verify_dhc
    @resources = Resource.joins(:grant)
                         .where('program = \'Digitizing Hidden Special Collections and Archives\' AND restricted is false and access_url LIKE \'http%\'')
                         .order(Arel.sql('RANDOM()'))

    @resources.in_batches do |resource|
      array_of_args = resource.ids.map { |x| [x] }
      ResourceValidatorJob.perform_bulk(array_of_args) unless resource.restricted?
    end

    # @resources.each do |resource|
    #   next unless resource.valid_url?

    #   ResourceValidatorJob.perform_later(resource) unless r.restricted?
    # end
  end

  def run_check
    @resource = Resource.find(params[:resource_id])
    # ResourceValidatorJob.perform_now(@resource) unless @resource.restricted
    ResourceValidatorJob.perform_async(@resource.id) unless @resource.restricted
    redirect_to grant_resource_path(@resource.grant, @resource)
  end

  def show
    # @resource = Resource.find(params[:id])
  end

  def index
    # @resources = Grant.find(params[:id])

    @resources = Resource.all
    @pagy, @links = pagy(@resources)

    respond_to do |format|
      format.html
      format.csv { send_data @resources.to_csv, filename: "grant-resources-#{Date.today}.csv" }
    end
  end

  def status; end

  private

  def set_resource
    @resource = Resource.find(params[:id])
  end

  def resource_params
    params.require(:resource).permit(
      :access_filename, :access_url, :checksum, :restricted,
      :restricted_comments, :grant_id
    )
  end
end
