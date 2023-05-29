# frozen_string_literal: true

require 'faraday'

##
# Status object
class Status < ApplicationRecord
  belongs_to :resource, counter_cache: true, touch: true

  def self.update_status(resource)
    # sleep 1..5

    # get resource URL
    Net::HTTP.get_response(URI.parse(resource.url)).code

    # Set the status to latest
  end

  def self.latest
    joins(:resource).where(resources: { restriced: false })
  end

  def update_cache(previous)
    # TODO: update overall status
    # resource.overall_status force_update: true if new_status_different?(previous)
  end

  private

  ##
  # Checks to see if the current status is different the previous
  # status.
  # @param [Status]
  def new_status_different?(previous)
    return true if previous.blank?

    status != previous.status
  end
end
