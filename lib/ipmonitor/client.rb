# frozen_string_literal: true

require 'faraday'
require 'faraday/follow_redirects'
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
      conn = Faraday.new(
        url: @url,
        ssl: { verify: false },
        headers: { 'User-Agent' => user_agent }
      )
      # https://www.rubydoc.info/gems/faraday-follow_redirects/0.3.0
      conn.use Faraday::FollowRedirects::Middleware

      # conn.get do |request| # this is slow and gets the entire request
      conn.head do |request|
        # TODO: set these options dynamically
        request.options.timeout      = 5
        request.options.open_timeout = 5
      end
    rescue Faraday::ConnectionFailed
      # @options[status: 800]
      raise Ipmonitor::Exceptions::ResourceFail, message: 'Connection failed', url: conn.url_prefix.to_s, status: 800
    rescue Faraday::TimeoutError
      # @response = Ipmonitor::Response.new({status: 801})
      raise Ipmonitor::Exceptions::ResourceFail, message: 'Connection timeout', url: conn.url_prefix.to_s, status: 801
    # rescue Faraday::OpenTimeoutError
    #   # @response.status = 504
    #   raise Ipmonitor::Exception::ResourceFail, message: 'Server timeout', url: conn.url_prefix.to_s, status: 504
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
