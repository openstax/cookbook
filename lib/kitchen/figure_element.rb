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
            enumerator_class: FigureElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :figure
    end

    # Returns the caption element
    #
    # @return [Element, nil]
    #
    def caption
      first('figcaption')
    end

    def baked_caption
      parent.first('div.os-caption-container')
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

    # Returns true if the figure is unnumbered
    #
    # @return [Boolean]
    #

    def unnumbered?
      has_class?('unnumbered')
    end

    # Returns true if the figure doesn't have id
    #
    # @return [Boolean]
    #

    def without_id?
      return false if id.present?

      true
    end

    # Returns true unless the figure is a subfigure or has the 'unnumbered' class,
    # or doesn't have an id (figures from injected exercises)
    #
    # @return [Boolean]

    def figure_to_number?
      return false if subfigure? || unnumbered? || without_id?

      true
    end

    # Returns true if figure has 'unnumbered' class or doesn't have an id (figures from injected exercises)
    # These figures shouldn't be numbered, but still have to be wrapped into 'os-figure' container
    # and have baked caption if it exists
    #
    # @return [Boolean]

    def unnumbered_figure_to_bake?
      unnumbered? || without_id?
    end
  end
end
