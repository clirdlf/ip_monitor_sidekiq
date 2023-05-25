# frozen_string_literal: true

##
# Grant class
class Grant < ApplicationRecord
  validates :title, presence: true
  validates :institution, presence: true
  validates :grant_number, presence: true
  validates :contact, presence: true
  validates :email, presence: true
  validates :submission, presence: true

  has_many :resources, dependent: :destroy
  has_many :statuses, through: :resources

  def self.to_csv
    attributes = %w[id title institution grant_number contact email submission_date program resource_count filename]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |_grant|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  def online_resources_count
    statuses.where('latest = true').where('status = ?', 'OK').size
  end

  def offline_resources_count
    total_resources_count - online_resources_count
  end

  def total_resources_count
    resources.size
  end

  def restricted_resources_count
    resources.where('restricted = true').size
  end

  def public_resources_count
    total_resources_count - restricted_resources_count
  end

  def availability_score
    total = resources.where('restricted = FALSE').size
    if total.zero?
      100
    else
      (online_resources_count / total.to_f) * 100
    end
  end
end
