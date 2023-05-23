# frozen_string_literal: true

class CreateResources < ActiveRecord::Migration[6.0]
  def change
    create_table :resources do |t|
      t.string :access_filename
      t.string :access_url
      t.string :checksum
      t.boolean :restricted
      t.text :restricted_comments
      t.references :grant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
