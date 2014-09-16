require "dropbox_sdk"
require "breadbox/client"

module Breadbox
  class DropboxClient < Client
    def access_token
      configuration.dropbox_access_token
    end

    def upload(options = {})
      path      = options[:path]
      file      = options[:file]
      overwrite = options[:overwrite] || false
      share     = options[:share]
      filepath  = filepath_from_paths_and_file(root_path, path, file)
      result    = client.put_file(filepath, file, overwrite)

      if share && result
        share_hash = client.shares(result["path"])
        share_hash["url"]
      elsif result
        result["path"]
      end
    end

    protected

    def missing_access_token
      raise MissingDropboxAccessToken, "You need a Dropbox Access Token."
    end

    def new_client_from_configuration
      ::DropboxClient.new(access_token)
    end

    def post_initialize
      validate_access_token
    end

    def validate_access_token
      if configuration.dropbox_access_token.to_s.empty?
        missing_access_token
      end
    end
  end
end

class MissingDropboxAccessToken < Exception; end
