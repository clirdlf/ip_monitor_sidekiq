# frozen_string_literal: true

# see https://github.com/geoblacklight/geomonitor/blob/master/lib/geomonitor/response.rb
module Ipmonitor
  ##
  # Server response
  class Response
    attr_reader :status, :response_code, :body, :request_url

    def initialize(response = {})
      @response = response
      parse_response
    end

    def is_an_exception?
      true if @response.try(:exception)
    end

    def parse_response
      @status = map_status_code
      @response_code = @response.status
      # @request_url = @response.env[:url].to_s
    end

    def map_status_code
      # https://developer.mozilla.org/en-US/docs/Web/HTTP/Status
      case @response.status
      when 200..299
        'OK'
      when 300..399
        'Redirected'
      when 400
        'Bad Request'
      when 401
        'Unauthorized'
      when 403
        'Forbidden'
      when 404
        'Not Found'
      when 408
        'Request Timeout'
      when 410
        'Gone'
      when 500
        'Internal Server Error'
      when 501
        'Not Implemented'
      when 502
        'Bad Gateway'
      when 503
        'Service Unavailable'
      when 504
        'Gateway Timeout'
      when 800
        'Faraday Connection Failed'
      when 801
        'Faraday Connection Timeout'
      else
        '??'
      end
    end
  end
end
