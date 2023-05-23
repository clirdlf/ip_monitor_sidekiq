# frozen_string_literal: true

class AddStatusesCountToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :statuses_count, :integer
  end
end
