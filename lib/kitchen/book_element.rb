# frozen_string_literal: true

module Kitchen
  # An element for an entire book
  #
  class BookElement < ElementBase

    # Creates a new +BookElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: BookElementEnumerator,
            short_type: :book)
    end

    # Returns the "body" element
    #
    # @return [Element]
    #
    def body
      first!('body')
    end

    # Returns the top metadata element
    #
    # @return [MetadataElement]
    #
    def metadata
      metadatas.first
    end

    # Returns the table of contents (toc) element
    #
    # @return [Element]
    #
    def toc
      first!('nav#toc')
    end

  end
end
