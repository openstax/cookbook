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
            enumerator_class: UnitElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :unit
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

    # Returns the title's text regardless of whether the title has been baked
    #
    # @return [String]
    #
    def title_text
      title.children.one? ? title.text : title.first('.os-text').text
    end

  end
end
