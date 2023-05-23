# frozen_string_literal: true

class AddProgramToGrants < ActiveRecord::Migration[6.0]
  def change
    add_column :grants, :program, :string

    change_column_null :grants, :program, 'Recordings at Risk'
  end
end
