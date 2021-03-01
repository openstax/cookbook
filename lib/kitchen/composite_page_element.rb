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
            enumerator_class: CompositePageElementEnumerator,
            short_type: :composite_page)
    end

    # Returns the title element (the one in the immediate children, not the one in the metadata)
    #
    # @raise [ElementNotFoundError] if no matching element is found
    # @return [Element]
    #
    def title
      # Get the title in the immediate children, not the one in the metadata.  Could use
      # CSS of ":not([data-type='metadata']) > [data-type='document-title'], [data-type='document-title']"
      # but xpath is shorter
      first!("./*[@data-type = 'document-title']")
    end

    # Returns true if this class represents the element for the given node
    #
    # @param node [Nokogiri::XML::Node] the underlying node
    # @return [Boolean]
    #
    def self.is_the_element_class_for?(node)
      node['data-type'] == 'composite-page'
    end

    # Returns true if this page is a book index
    #
    # @return [Boolean]
    #
    def is_index?
      has_class?('os-index-container')
    end

  end
end
