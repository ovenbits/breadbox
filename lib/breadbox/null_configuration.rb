require "breadbox/configuration"

module Breadbox
  class NullConfiguration < Configuration
    def provider
      raise MissingBreadboxProvider, "must provide a valid provider."
    end
  end
end

class MissingBreadboxProvider < Exception; end
