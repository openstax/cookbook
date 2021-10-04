# frozen_string_literal: true

module Kitchen
  # An element for an example
  #
  class SectionElement < ElementBase

    # Creates a new +SectionElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: SectionElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :section
    end

  end
end
