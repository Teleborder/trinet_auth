require 'faraday'
require File.expand_path('../version', __FILE__)

module TrinetAuth
  # Defines constants and methods related to configuration
  module Configuration
    # An array of valid keys in the options hash when configuring a {Instagram::API}
    VALID_OPTIONS_KEYS = [
      :adapter,
      :endpoint,
      :format,
      :user_agent,
      :cookie_name
    ].freeze

    # The adapter that will be used to connect if none is set
    #
    # @note The default faraday adapter is Net::HTTP.
    DEFAULT_ADAPTER = Faraday.default_adapter

    # The endpoint that will be used to connect if none is set
    #
    DEFAULT_ENDPOINT = "https://gatewaybib.hrpassport.com/trinetAuth/services/v1.0/authentication".freeze

    DEFAULT_COOKIE_NAME = "TriNetAuthCookieBIB"

    # The response format appended to the path and sent in the 'Accept' header if none is set
    #
    # @note JSON is the only available format at this time
    DEFAULT_FORMAT = :json

    # The user agent that will be sent to the API endpoint if none is set
    DEFAULT_USER_AGENT = "Trinet Auth Ruby Gem #{TrinetAuth::VERSION}".freeze

    # An array of valid request/response formats
    #
    # @note Not all methods support the XML format.
    VALID_FORMATS = [
      :json].freeze

    # @private
    attr_accessor *VALID_OPTIONS_KEYS

    # When this module is extended, set all configuration options to their default values
    def self.extended(base)
      base.reset
    end

    # Convenience method to allow configuration options to be set in a block
    def configure
      yield self
    end

    # Create a hash of options and their values
    def options
      VALID_OPTIONS_KEYS.inject({}) do |option, key|
        option.merge!(key => send(key))
      end
    end

    # Reset all configuration options to defaults
    def reset
      self.adapter = DEFAULT_ADAPTER
      self.endpoint = DEFAULT_ENDPOINT
      self.format = DEFAULT_FORMAT
      self.user_agent = DEFAULT_USER_AGENT
      self.cookie_name = DEFAULT_COOKIE_NAME
    end
  end
end
