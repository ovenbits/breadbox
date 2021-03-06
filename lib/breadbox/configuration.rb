module Breadbox
  class Configuration
    attr_accessor :s3_bucket,
                  :s3_access_key_id,
                  :s3_secret_access_key,
                  :dropbox_access_token,
                  :provider,
                  :root_path

    attr_writer :s3_region

    def initialize
      @root_path = default_root_path
    end

    def provider=(candidate)
      if valid_provider?(candidate)
        @provider = candidate
      else
        raise InvalidBreadboxProvider, "must use a valid provider."
      end
    end

    def s3_region
      @s3_region || default_s3_region
    end

    protected

    def default_s3_region
      "us-east-1"
    end

    def default_root_path
      "/"
    end

    def valid_provider?(candidate)
      valid_providers.include?(candidate.to_sym)
    end

    def valid_providers
      [:s3, :dropbox]
    end
  end
end

class InvalidBreadboxProvider < Exception; end
