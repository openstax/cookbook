# frozen_string_literal: true

module Kitchen
  # An element for a chapter
  #
  class ChapterElement < ElementBase

    # Creates a new +ChapterElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: ChapterElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :chapter
    end

    # Returns the title element (the one in the immediate children, not the one in the metadata)
    #
    # @raise [ElementNotFoundError] if no matching element is found
    # @return [Element]
    #
    def title
      # Get the title in the immediate children, not the one in the metadata.  Could use
      # CSS of ":not([data-type='metadata']) >
      #       [data-type='document-title'], [data-type='document-title']"
      # but xpath is shorter
      first!("./*[@data-type = 'document-title']")
    end

    # Returns the introduction page
    #
    # @return [Element, nil]
    #
    def introduction_page
      pages('.introduction').first
    end

    # Returns an enumerator for the glossaries
    #
    # @return [ElementEnumerator]
    #
    def glossaries
      search("div[data-type='glossary']")
    end

    # Returns an enumerator for the key equations
    #
    # @return [ElementEnumerator]
    #
    def key_equations
      search('section.key-equations')
    end

    # Returns an enumerator for the abstracts
    #
    # @return [ElementEnumerator]
    #
    def abstracts
      search('[data-type="abstract"]')
    end

  end
end
