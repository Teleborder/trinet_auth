require "trinet_auth/configuration"
require "trinet_auth/client"

module TrinetAuth
  extend Configuration

  def self.client(options={})
    Client.new(options)
  end

  # Delegate to Trinet::Client
  def self.method_missing(method, *args, &block)
    return super unless client.respond_to?(method)
    client.send(method, *args, &block)
  end

  # Delegate to Trinet::Client
  def self.respond_to?(method, include_all=false)
    return client.respond_to?(method, include_all) || super
  end
end
