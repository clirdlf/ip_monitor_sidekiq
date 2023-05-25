# frozen_string_literal: true

##
# Resource object
class Resource < ApplicationRecord
  belongs_to :grant, counter_cache: true
  has_many :statuses, dependent: :destroy
  has_one :latest_status,
          ->(_object) { where('latest = ?', true) }, class_name: 'Status'

  ##
  # Generate CSV of the data
  def self.to_csv
    attributes = %w[id access_filename access_url checksum restricted restricted_comments latest_status]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |_grant|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  ##
  # Run a check on the resource
  def run_check
    # sleep?
    client = Ipmonitor::Client.new(access_url)
    response = client.create_response

    @current = statuses.create(
      {
        response_code: response.response_code,
        response_time: client.elapsed_time,
        status: response.status,
        latest: true
      }
    )

    # update_status

    # Update Resource with latest status
    old_statuses = Status.where(resource_id: id).where('id != ?', @current.id)
                         .where(latest: true)

    @current.update_cache(old_statuses.last)

    return if old_statuses.empty?

    old_statuses.each do |old|
      old.latest = false
      old.save
    end
  end

  def restricted_count; end

  def validate
    ResourceValidatorJob.perform_now(@resource)
  end

  ##
  # Current status of the Resource
  def current_status
    Status.find_by(resource_id: id, latest: true)
  end

  ##
  # Recent status OK and last 7
  def recent_status
    last_seven = Status.where(resource_id: id).last(7)
    ok_count = last_seven.count { |stat| stat.status == 'OK' }
    { ok: ok_count.to_f, count: last_seven.count.to_f }
  end

  ##
  # Calculates the percentage of "OK" statuses
  def recent_status_score
    recent_status[:ok] / recent_status[:count]
  end

  # Test if a URL is valid
  def valid_url?
    uri = URI.parse(access_url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  ##
  # Set the last status to the "latest"
  def self.update_status
    old_statuses = Status.where(resource_id: id).where('id != ?', current.id)
                         .where(latest: true)
    @current.update_cache(old_statuses.last)

    return if old_statuses.empty?

    old_statuses.each do |old|
      old.latest = false
      old.save
    end
  end
end
