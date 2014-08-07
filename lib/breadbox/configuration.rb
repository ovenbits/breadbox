module Breadbox
  class Configuration
    attr_accessor :dropbox_access_token, :root_path

    def initialize
      @root_path = default_root_path
    end

    protected

    def default_root_path
      "/"
    end
  end
end
