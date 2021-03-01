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
            enumerator_class: TermElementEnumerator,
            short_type: :term)
    end

    # Returns true if this class represents the element for the given node
    #
    # @param node [Nokogiri::XML::Node] the underlying node
    # @return [Boolean]
    #
    def self.is_the_element_class_for?(node)
      node['data-type'] == 'term'
    end

  end
end
