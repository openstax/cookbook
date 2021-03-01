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
            enumerator_class: ExampleElementEnumerator,
            short_type: :example)
    end

    # Returns the an enumerator for titles.
    #
    # @return [ElementEnumerator]
    #
    def titles
      search("span[data-type='title']")
    end

    # Returns true if this class represents the element for the given node
    #
    # @param node [Nokogiri::XML::Node] the underlying node
    # @return [Boolean]
    #
    def self.is_the_element_class_for?(node)
      node['data-type'] == 'example'
    end

  end
end
