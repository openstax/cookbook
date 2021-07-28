# frozen_string_literal: true

module Kitchen
  # An element for an example
  #
  class ExampleElement < ElementBase

    # Creates a new +ExampleElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: ExampleElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :example
    end

    # Returns the an enumerator for titles.
    #
    # @return [ElementEnumerator]
    #
    def titles_to_rename
      titles(except: \
        lambda do |title|
          title.parent.has_class?('os-caption-container') || \
          title.parent.has_class?('os-caption') || \
          title.parent.name == 'caption' || \
          title.parent[:'data-type'] == 'note'
        end
      )
    end
  end
end
