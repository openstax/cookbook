# Make debug output more useful (dumping entire document out is not useful)
module Nokogiri
  module XML
    class Document
      def inspect
        "Nokogiri::XML::Document <hidden for brevity>"
      end

      def alphabetize_attributes!
        traverse do |child|
          next if child.text? || child.document?
          child_attributes = child.attributes
          child_attributes.each do |key, value|
            child.remove_attribute(key)
          end
          sorted_keys = child_attributes.keys.sort
          sorted_keys.each do |key|
            value = child_attributes[key].to_s
            child[key] = value
          end
        end
      end
    end

    class Node
      def inspect
        to_s
      end
    end
  end
end
