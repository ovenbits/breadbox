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
    @client ||= Client.new(token: configuration.dropbox_access_token).client
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
end
