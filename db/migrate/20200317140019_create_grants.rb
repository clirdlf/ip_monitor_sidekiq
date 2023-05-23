# frozen_string_literal: true

class CreateGrants < ActiveRecord::Migration[6.0]
  def change
    create_table :grants do |t|
      t.string :title
      t.string :institution
      t.string :grant_number
      t.string :contact
      t.string :email
      t.date :submission

      t.timestamps
    end
  end
end
