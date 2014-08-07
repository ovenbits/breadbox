require "dropbox_sdk"

module Breadbox
  class Client
    attr_reader :client, :root_path, :token

    def initialize(options = {})
      @token     = options[:token]
      @root_path = options[:root_path]
      @client    = new_client_from_token
    end

    def upload(path: nil, file: nil)
      filepath = filepath_from_paths_and_file(root_path, path, file)
      client.put_file(filepath, file)
    end

    protected

    def filepath_from_paths_and_file(root_path, path, file)
      filename = File.basename(file)
      [root_path, path, filename].join("/").gsub(/\/{2,}/, '/')
    end

    def new_client_from_token
      if token.nil? || token.empty?
        raise MissingAccessToken, "You need a Dropbox Access Token."
      else
        DropboxClient.new(token)
      end
    end
  end
end

class MissingAccessToken < Exception; end
