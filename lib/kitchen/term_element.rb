# frozen_string_literal: true

module Kitchen
  # An element for a term
  #
  class TermElement < ElementBase

    # Creates a new +TermElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: TermElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :term
    end

  end
end
