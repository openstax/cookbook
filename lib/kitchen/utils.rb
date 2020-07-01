module Kitchen
  module Utils

    def self.search_path_to_type(search_path)
      [search_path].flatten.join(",")
    end

  end
end
