# frozen_string_literal: true

module Ipmonitor
  # @see https://stackoverflow.com/questions/6934185/ruby-net-http-following-redirects
  class UrlResolver
    def self.resolve(uri, agent = '', max_attempts = 10); end
  end
end
