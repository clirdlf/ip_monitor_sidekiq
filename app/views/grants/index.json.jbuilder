# frozen_string_literal: true

json.array! @grants, partial: 'grants/grant', as: :grant
