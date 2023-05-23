# frozen_string_literal: true

class CreateStatuses < ActiveRecord::Migration[6.0]
  def change
    create_table :statuses do |t|
      t.string :response_code
      t.string :response_message
      t.decimal :response_time
      t.string :status
      t.boolean :latest
      t.text :status_message
      t.references :resource, null: false, foreign_key: true

      t.timestamps
    end
  end
end
