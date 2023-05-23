class AddFilenameToGrants < ActiveRecord::Migration[6.0]
  def change
    add_column :grants, :filename, :string

    add_index :grants, :filename, unique: true
  end
end
