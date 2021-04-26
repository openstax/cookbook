# frozen_string_literal: true

module Kitchen
  # An element for a page
  #
  class PageElement < ElementBase

    # Creates a new +PageElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: PageElementEnumerator,
            short_type: :page)
    end

    # Returns the title element.  This method is aware that the title of the
    # introduction page moves during the baking process.
    #
    # @raise [ElementNotFoundError] if no matching element is found
    # @return [Element]
    #
    def title
      # The selector for intro titles changes during the baking process
      first!(is_introduction? ? selectors.title_in_introduction_page : selectors.title_in_page)
    end

    # Returns the title's text regardless of whether the title has been baked
    #
    # @return [String]
    #
    def title_text
      title.children.one? ? title.text : title.first('.os-text').text
    end

    # Returns an enumerator for titles.
    #
    # @return [ElementEnumerator]
    #
    def titles
      search("div[data-type='document-title']")
    end

    # Returns true if this page is an introduction
    #
    # @return [Boolean]
    #
    def is_introduction?
      has_class?('introduction')
    end

    # Returns true if this page is a preface
    #
    # @return [Boolean]
    #
    def is_preface?
      has_class?('preface')
    end

    # Returns true if this page is an appendix
    #
    # @return [Boolean]
    #
    def is_appendix?
      has_class?('appendix')
    end

    # Returns the metadata element.
    #
    # @raise [ElementNotFoundError] if no matching element is found
    # @return [Element]
    #
    def metadata
      first!("div[data-type='metadata']")
    end

    # Returns the summary element.
    #
    # @raise [ElementNotFoundError] if no matching element is found
    # @return [Element]
    #
    def summary
      first!(selectors.page_summary)
    end

    # Returns the exercises element.
    #
    # @raise [ElementNotFoundError] if no matching element is found
    # @return [Element]
    #
    def exercises
      first!('section.exercises')
    end

    # Returns the key concepts
    #
    # @return [Element]
    #
    def key_concepts
      search('section.key-concepts')
    end

    # Returns true if this class represents the element for the given node
    #
    # @param node [Nokogiri::XML::Node] the underlying node
    # @return [Boolean]
    #
    def self.is_the_element_class_for?(node)
      node['data-type'] == 'page'
    end

  end
end
