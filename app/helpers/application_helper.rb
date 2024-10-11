# frozen_string_literal: true

##
# Application Helpfer methods
module ApplicationHelper
  include Pagy::Frontend

  def flash_class(level)
    alerts = {
      'notice' => 'alert alert-info',
      'success' => 'alert alert-success',
      'error' => 'alert alert-error',
      'alert' => 'alert alert-error'
    }
    alerts[level]
  end
end
