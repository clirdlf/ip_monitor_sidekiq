# frozen_string_literal: true

##
# (HTTP) Status for resource
class StatusesController < ApplicationController
  before_action :set_grant, only: %i[show edit status update destroy]

  def check_status; end

  private

  def set_resource
    @resource = Resource.find(params[:id])
  end
end
