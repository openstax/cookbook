# frozen_string_literal: true
module Kitchen
  # Utility methods
  #
  module Utils
    # A standard way to convert a search path to an element type
    #
    # @param search_path [String, Array<String>] selectors
    # @return [String]
    #
    def self.search_path_to_type(search_path)
      [search_path].flatten.join(',')
    end
  end
end
