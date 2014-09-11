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

  def self.cleanup(file: nil, cleanup: true)
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

  def self.upload(path: nil, file: nil, cleanup: false)
    if client.upload(path: path, file: file)
      cleanup(file: file, cleanup: cleanup)
      true
    end
  end
end
