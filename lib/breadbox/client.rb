require "breadbox/null_configuration"

module Breadbox
  class Client
    attr_reader :configuration

    def initialize(configuration = nil)
      @configuration = configuration || NullConfiguration.new
      post_initialize
    end

    def client
      @client ||= new_client_from_configuration
    end

    def root_path
      configuration.root_path
    end

    def upload(*)
      not_implemented
    end

    protected

    def filepath_from_paths_and_filename(root_path, path, filename)
      [root_path, path, filename].join("/").gsub(/\/{2,}/, "/")
    end

    def new_client_from_configuration
      not_implemented
    end

    def not_implemented
      raise NotImplementedError,
            "has not been implemented on #{ self.class }"
    end

    def post_initialize; end
  end
end
