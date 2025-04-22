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
            enumerator_class: PageElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :page
    end

    # Returns the title element.  This method is aware that the title of the
    # introduction page moves during the baking process.
    #
    # @raise [ElementNotFoundError] if no matching element is found
    # @return [Element]
    #
    def title(reload: false)
      # The selector for intro titles changes during the baking process
      @title ||= begin
        selector = is_introduction? ? selectors.title_in_introduction_page : selectors.title_in_page
        search(selector, reload: reload).map do |title|
          next if title.parent[:'data-type'] == 'metadata'

          return title
        end
        raise "Title not found for page id=#{id}"
      end
    end

    # Returns the title's text regardless of whether the title has been baked
    #
    # @return [String]
    #
    def title_text
      title.children.one? ? title.text : title.first('.os-text').text
    end

    # Returns the title's primary children regardless of whether the title has been baked
    #
    # @return [Element]
    #
    def title_children
      title_os_text = title.search('.os-text').first # module titles which are already baked
      title_os_text ? title_os_text.children : title.children
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
      @is_introduction ||= has_class?('introduction')
    end

    # Returns true if this page is a unit closer
    #
    # @return [Boolean]
    #
    def is_unit_closer?
      @is_unit_closer ||= has_class?('unit-closer')
    end

    # Returns  replaces generic call to page.count_in(:chapter)
    #
    # @raise [StandardError] if called on an introduction page
    # @return [Integer]
    #
    def count_in_chapter_without_intro_page
      raise 'Introduction pages cannot be counted with this method' if is_introduction?

      count_in(:chapter) - (ancestor(:chapter).has_introduction? ? 1 : 0)
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
    # @return [Element, nil] the summary or nil if no summary found
    #
    def summary
      first(selectors.page_summary)
    end

    # Returns the free response questions
    #
    # @return [Element]
    #
    def free_response
      search('section.free-response')
    end

    # Returns true if this page is a handbook
    #
    # @return [Boolean]
    #
    def is_handbook?
      has_class?('handbook')
    end

  end
end
