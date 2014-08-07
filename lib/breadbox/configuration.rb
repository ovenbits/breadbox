module Breadbox
  class Configuration
    attr_accessor :dropbox_access_token, :root_directory

    def initialize
      @root_directory = default_root_directory
    end

    protected

    def default_root_directory
      "/breadbox"
    end
  end
end
