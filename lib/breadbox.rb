require "breadbox/version"
require "breadbox/configuration"
require "breadbox/client"
require "breadbox/client_builder"

begin
  require "pry"
rescue LoadError
end

module Breadbox
  class << self
    attr_writer :configuration
  end

  def self.cleanup(options = {})
    file    = options[:file]
    cleanup = options[:cleanup]

    if cleanup && File.exists?(file)
      File.delete(file)
    end
  end

  def self.client
    @client ||= ClientBuilder.build(configuration)
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

  def self.upload(options = {})
    if result = client.upload(options)
      cleanup(options)
      result
    end
  end
end
