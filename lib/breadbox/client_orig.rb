require "dropbox_sdk"

module Breadbox
  class Client
    attr_reader :root_path, :token

    def initialize(options = {})
      @token     = evaluate_token(options[:token])
      @root_path = options[:root_path]
    end

    def client
      @client ||= new_client_from_token
    end

    def upload(path: nil, file: nil)
      filepath = filepath_from_paths_and_file(root_path, path, file)
      client.put_file(filepath, file)
    end

    protected

    def evaluate_token(token = nil)
      if token.to_s.empty?
        missing_access_token
      else
        token
      end
    end

    def filepath_from_paths_and_file(root_path, path, file)
      filename = File.basename(file)
      [root_path, path, filename].join("/").gsub(/\/{2,}/, '/')
    end

    def missing_access_token
      raise MissingAccessToken, "You need a Dropbox Access Token."
    end

    def new_client_from_token
      DropboxClient.new(token)
    end
  end
end

class MissingAccessToken < Exception; end
