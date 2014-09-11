require "breadbox/dropbox_client"
require "breadbox/s3_client"
require "breadbox/null_configuration"

module Breadbox
  class ClientBuilder
    attr_reader :configuration

    def initialize(configuration = nil)
      @configuration = configuration || null_configuration
    end

    def build
      case configuration.provider
      when :dropbox
        DropboxClient.new(configuration)
      when :s3
        S3Client.new(configuration)
      else
        null_configuration.provider
      end
    end

    def self.build(configuration)
      new(configuration).build
    end

    protected

    def null_configuration
      NullConfiguration.new
    end
  end
end
