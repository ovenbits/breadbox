require "breadbox/version"
require "breadbox/configuration"
require "breadbox/client"

begin
  require "pry"
rescue LoadError
end

module Breadbox
  class << self
    attr_writer :configuration
  end

  def self.client
    @client ||= Client.new(
      root_path: configuration.root_path,
      token: configuration.dropbox_access_token,
    )
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset
    @client        = nil
    @configuration = Configuration.new
  end

  def self.upload(options)
    client.upload(options)
  end
end
