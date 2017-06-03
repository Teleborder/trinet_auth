require 'faraday'
require 'faraday_middleware'

require 'trinet_auth/version'
require 'trinet_auth/configuration'
require 'trinet_auth/client/auth'

module TrinetAuth
  class RequestError < StandardError; end

  class Client
    include TrinetAuth::Client::Auth

    attr_accessor *Configuration::VALID_OPTIONS_KEYS

    def initialize(options={})
      options = TrinetAuth.options.merge(options)
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        send("#{key}=", options[key])
      end
    end

    def config
      conf = {}
      Configuration::VALID_OPTIONS_KEYS.each do |key|
        conf[key] = send key
      end
      conf
    end

    private

    def get(path, params = {})
      request(:get, path, params)
    end

    def post(path, params = {}, body)
      request(:post, path, params, body)
    end

    def patch(path, params = {}, body)
      request(:patch, path, params, body)
    end

    def delete(path, params = {})
      request(:delete, path, params)
    end

    def request(method, path, parameters, body = nil)
      response = connection.send(method.to_sym, path, parameters) do |req|
        req.params['realm'] = 'sw_hrp'
        unless auth_token.nil?
          req.headers['Cookie'] = "#{cookie_name}=#{auth_token}"
        end
        unless body.nil?
          req.headers['Content-Type'] = 'application/json'
          req.body = body.to_json
        end
      end
      response.body
    rescue Faraday::Error::ClientError
      raise TrinetAuth::RequestError, $!, $!.backtrace
    end

    def connection
      Faraday.new(endpoint, proxy: proxy) do |conn|
        conn.use Faraday::Response::RaiseError
        conn.request :url_encoded
        conn.response :json, :content_type => /\bjson$/
        conn.adapter adapter
        conn.headers[:user_agent] = user_agent
        conn.response :logger if ENV["DEBUG"]
      end
    end
  end
end
