# frozen_string_literal: true

json.extract! grant, :id, :title, :institution, :grant_number, :contact, :email, :submission, :created_at, :updated_at
json.url grant_url(grant, format: :json)
