# frozen_string_literal: true

module Kitchen
  # Builds Elements from Nokogiri Nodes
  #
  class ElementFactory

    ELEMENT_CLASSES = ElementBase.descendants

    # Builds a new concrete subclass of ElementBase for the provided node.
    #
    # @param node [Nokogiri::XML::Node] the node to wrap in an element
    # @param document [Document] the document
    # @param element_class [ElementBase] actually a subclass of +ElementBase+ to
    #   use when wrapping the node.
    # @param default_short_type [Symbol, String] if we are making an instance
    #   of an element class where we know the short_type we'll use that; otherwise
    #   we'll make an Element instance and use this argument as the short_type.
    # @param detect_element_class [Boolean] if true and +element_class+ is not given,
    #   attempts to detect the element class from the node
    # @return [ElementBase] actually a subclass of +ElementBase+
    #
    def self.build_from_node(node:,
                             document:,
                             element_class: nil,
                             default_short_type: nil,
                             detect_element_class: false)
      element_class ||= detect_element_class ? find_element_class(node, document.config) : Element

      if element_class == Element
        element_class.new(node: node,
                          document: document,
                          short_type: default_short_type)
      else
        element_class.new(node: node,
                          document: document)
      end
    end

    def self.find_element_class(node, config)
      ELEMENT_CLASSES.find do |klass|
        klass.is_the_element_class_for?(node, config: config)
      end || Element
    end

  end
end
