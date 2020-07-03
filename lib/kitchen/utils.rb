module Kitchen
  module Utils

    def self.search_path_to_type(search_path)
      [search_path].flatten.join(",")
    end

    def self.normalized_xhtml_string(xml_thing_with_to_s)
      doc = Nokogiri::XML(xml_thing_with_to_s.to_s) do |config|
        config.noblanks
      end

      doc.alphabetize_attributes!

      doc.to_xhtml(indent: 2)
    end

  end
end
