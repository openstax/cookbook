# frozen_string_literal: true

module Kitchen
  # An element for a composite page
  #
  class CompositePageElement < ElementBase

    # Creates a new +CompositePageElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: CompositePageElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :composite_page
    end

    # Returns the title element (the one in the immediate children, not the one in the metadata)
    #
    # @raise [ElementNotFoundError] if no matching element is found
    # @return [Element]
    #
    def title
      first!('h3[data-type="title"], h2[data-type="document-title"],' \
             'h1[data-type="document-title"]')
    end

    # Returns true if this page is a book index
    #
    # @return [Boolean]
    #
    def is_index?
      has_class?('os-index-container')
    end

    # Returns true if this page is a book index of type
    #
    # @return [Boolean]
    #
    def is_index_of_type?
      (self[:class] || '').match?(/os-index-.+-container/)
    end

    # In books we can find two types of EOB References.
    #
    # One of them has form similar to footnotes. There are citation links in the text that provides
    # to the reference note at the end of the book.
    #
    # Second one is a section with references on the Introduction page that is moved to the EOB.
    #
    # Difference in classes is important.

    # Returns true if this page is a book citation reference
    #
    # @return [Boolean]
    #
    def is_citation_reference?
      has_class?('os-eob os-reference-container')
    end

    # Returns true if this page is a book section reference
    #
    # @return [Boolean]
    #
    def is_section_reference?
      has_class?('os-eob os-references-container')
    end

  end
end
