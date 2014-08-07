require "breadbox/version"
require "breadbox/configuration"

begin
  require "pry"
rescue LoadError
end

module Breadbox
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset
    @configuration = Configuration.new
  end
end
