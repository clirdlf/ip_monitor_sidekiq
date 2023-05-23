class AddResourceCountToGrant < ActiveRecord::Migration[6.0]
  def change
    add_column :grants, :resources_count, :integer
  end
end
