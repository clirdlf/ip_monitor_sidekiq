# frozen_string_literal: true

require 'faraday'
require 'faraday/follow_redirects'
require 'faraday/retry'
require 'net/http'
require 'uri'

module Ipmonitor
  ##
  # Create a client to interact with remote objects and return information on
  # the resource's status code.
  class Client
    attr_accessor :start_time, :end_time

    ##
    # Create a new Ipmonitor::Client for a given URL
    #
    # @param url [String]
    # @return [Ipmonitor::Client]
    def initialize(url)
      @url = URI.parse(url)
    end

    ##
    # Create a new response for the resource
    # @return [Ipmonitor::Response]
    def create_response
      @start_time = Time.now

      begin
        response = check_resource
      rescue Ipmonitor::Exceptions::ResourceFail => e
        response = e
      end

      @end_time = Time.now
      Ipmonitor::Response.new(response)
    end

    def user_agent
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36'
    end

    ##
    # Checks if a resource is online (following redirects)
    def check_resource
      # https://github.com/lostisland/faraday-retry#usage
      retry_options = {
        max: 2,
        interval: 0.05,
        interval_randomness: 0.5,
        backoff_factor: 2
      }

      # conn = Faraday.new do (
      #   url: @url,
      #   ssl: { verify: false },
      #   headers: { 'User-Agent' => user_agent }
      # )
      conn = Faraday.new(@url, {ssl: { verify: false }}) do |f|
        f.request :retry, retry_options
        f.headers { 'User-Agent' => user_agent }
        f.response :raise_error
      end
      # https://www.rubydoc.info/gems/faraday-follow_redirects/0.3.0
      conn.use Faraday::FollowRedirects::Middleware
      
      begin
        # conn.get do |request| # this is slow and gets the entire request
        conn.head do |request|
          # TODO: set these options dynamically
          request.options.timeout      = 5
          request.options.open_timeout = 5
        end
        # https://lostisland.github.io/faraday/middleware/raise-error
        # TODO: map error responses into it's own class to map ResourceFail to messages
      rescue Faraday::BadRequestError
        raise Ipmonitor::Exceptions::ResourceFail, message: 'Bad Request', url: conn.url_prefix.to_s, status: 400
      rescue Faraday::UnauthorizedError
        raise Ipmonitor::Exceptions::ResourceFail, message: 'Unauthorized', url: conn.url_prefix.to_s, status: 401
      rescue Faraday::ForbiddenError
        raise Ipmonitor::Exceptions::ResourceFail, message: 'Forbidden', url: conn.url_prefix.to_s, status: 403
      rescue Faraday::ResourceNotFound
        raise Ipmonitor::Exceptions::ResourceFail, message: 'Not Found', url: conn.url_prefix.to_s, status: 404
      rescue Faraday::ProxyAuthError
        raise Ipmonitor::Exceptions::ResourceFail, message: 'Proxy Auth Error', url: conn.url_prefix.to_s, status: 407
      rescue Faraday::ConflictError
        raise Ipmonitor::Exceptions::ResourceFail, message: 'Conflict Error', url: conn.url_prefix.to_s, status: 409
      rescue Faraday::UnprocessableEntityError
        raise Ipmonitor::Exceptions::ResourceFail, message: 'Conflict Error', url: conn.url_prefix.to_s, status: 422
      rescue Faraday::ConnectionFailed
        # @options[status: 800]
        raise Ipmonitor::Exceptions::ResourceFail, message: 'Connection failed', url: conn.url_prefix.to_s, status: 800
      rescue Faraday::TimeoutError
        # @response = Ipmonitor::Response.new({status: 801})
        raise Ipmonitor::Exceptions::ResourceFail, message: 'Connection timeout', url: conn.url_prefix.to_s, status: 801
      rescue Faraday::ServerError => e
      #   # @response.status = 504
        raise Ipmonitor::Exceptions::ResourceFail, message: 'Server Error', url: conn.url_prefix.to_s, status: e.response[:status]
      end
    end

    ##
    # Calculated request time for the resource
    # @return [Float]
    def elapsed_time
      @end_time - @start_time if @start_time && end_time
    end

    private

    ##
    # Returns timeout for the external request
    # @return [Fixnum] request timeout in seconds
    def timeout
      @options[:timeout] || 5
    end
  end
end
