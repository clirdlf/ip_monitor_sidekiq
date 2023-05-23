# frozen_string_literal: true

class ResourceValidatorJob < ApplicationJob
  # queue_as :low_priority # for additional queues

  discard_on ActiveJob::DeserializationError

  queue_as :default

  def perform(resource)
    resource.run_check
  end
end
