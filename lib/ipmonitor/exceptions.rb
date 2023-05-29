# frozen_string_literal: true

module Ipmonitor
  ##
  # Custom client exceptions
  class Exceptions
    ##
    # Resource Fail Error (e.g. 5xx errors)
    class ResourceFail < StandardError
      def initialize(options = {})
        @options = options
      end

      def request_url
        @options[:request_url].to_s
      end

      def status
        @options[:status]
      end
    end

    class NoDocumentFound < StandardError
    end
  end
end
