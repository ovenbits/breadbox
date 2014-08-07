require "dropbox_sdk"

module Breadbox
  class Client
    attr_reader :client, :token

    def initialize(options = {})
      @token  = options[:token]
      @client = new_client_from_token
    end

    protected

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
