# frozen_string_literal: true

module Kitchen
  # An element for metadata
  #
  class MetadataElement < ElementBase
    # Creates a new +MetadataElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: MetadataElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :metadata
    end

    # Returns set of selected data elements
    #
    # @return [ElementEnumerator]
    #
    def children_to_keep
      search(%w([data-type='revised'] .authors .publishers .print-style .permissions
                [data-type='subject']))
    end
  end
end
