# frozen_string_literal: true

module Kitchen
  # An element for an image
  #
  class ImageElement < ElementBase

    # Creates a new +ImageElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: ImageElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :image
    end

    def src
      self[:src]
    end

    def resource_key
      raise "ERROR: Invalid format for `src` on #{self}." unless src.match(/\.\.\/resources\/[\w\d]*/)

      src.gsub('../resources/', '').to_sym
    end

  end
end
