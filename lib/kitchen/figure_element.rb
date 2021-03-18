# frozen_string_literal: true

module Kitchen
  # An element for a figure
  #
  class FigureElement < ElementBase

    # Creates a new +FigureElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: FigureElementEnumerator,
            short_type: :figure)
    end

    # Returns the caption element
    #
    # @return [Element, nil]
    #
    def caption
      first('figcaption')
    end

    # Returns the Figure Title
    #
    # @return [Element, nil]
    #
    def title
      first("div[data-type='title']")
    end

    # Returns true if the figure is a child of another figure
    #
    # @return [Boolean]
    #
    def subfigure?
      parent.name == 'figure'
    end

    # Returns true if this class represents the element for the given node
    #
    # @param node [Nokogiri::XML::Node] the underlying node
    # @return [Boolean]
    #
    def self.is_the_element_class_for?(node)
      node.name == 'figure'
    end

  end
end
