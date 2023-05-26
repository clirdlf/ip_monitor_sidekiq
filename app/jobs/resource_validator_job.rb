# frozen_string_literal: true

class ResourceValidatorJob
  # @see https://andycroll.com/ruby/use-sidekiq-directly-not-through-active-job/
  include Sidekiq::Job
  # queue_as :low_priority # for additional queues

  # discard_on ActiveJob::DeserializationError

  # queue_as :default

  def perform(id)
    resource = Resource.find_by(id: id)
    resource.run_check unless resource.restricted?
  end
end
