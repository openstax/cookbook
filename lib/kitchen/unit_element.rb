# frozen_string_literal: true

module Kitchen
  # An element for a unit
  #
  class UnitElement < ElementBase

    # Creates a new +UnitElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: UnitElementEnumerator,
            short_type: :unit)
    end

    # Get the title in the immediate children, not the one in the metadata.  Could use
    # CSS of ":not([data-type='metadata']) >
    #         [data-type='document-title'], [data-type='document-title']"
    # but xpath is shorter
    # @return [Element]
    #
    def title
      first!("./*[@data-type = 'document-title']")
    end

    # Returns true if this class represents the element for the given node
    #
    # @param node [Nokogiri::XML::Node] the underlying node
    # @return [Boolean]
    #
    def self.is_the_element_class_for?(node)
      node['data-type'] == 'unit'
    end
  end
end
