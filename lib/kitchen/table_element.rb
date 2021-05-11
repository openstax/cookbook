# frozen_string_literal: true

module Kitchen
  # An element for a table
  #
  class TableElement < ElementBase

    # Creates a new +TableElement+
    #
    # @param node [Nokogiri::XML::Node] the node this element wraps
    # @param document [Document] this element's document
    #
    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: TableElementEnumerator)
    end

    # Returns the short type
    # @return [Symbol]
    #
    def self.short_type
      :table
    end

    # Returns an element for the title row, if present
    #
    # @return [Element, nil]
    #
    def title_row
      top_titled? ? first('thead').first('tr') : nil
    end

    # Returns the title nodes in the first title row element
    #
    # @return [Nokogiri::XML::NodeSet] Unusual to return the raw Nokogiri nodes!
    #
    def title
      # TODO: replace +children+ with +element_children+?
      title_row&.first('th')&.children
    end

    # Returns true if the table has a title at the top
    #
    # @return [Boolean]
    #
    def top_titled?
      has_class?('top-titled')
    end

    # Returns true if the table is unnumbered
    #
    # @return [Boolean]
    #
    def unnumbered?
      has_class?('unnumbered')
    end

    # Returns true if the table is unstyled
    #
    # @return [Boolean]
    #
    def unstyled?
      has_class?('unstyled')
    end

    # Returns true if the table has a column header
    #
    # @return [Boolean]
    #
    def column_header?
      has_class?('column-header')
    end

    # Returns an element for the table caption, if present
    #
    # @return [Element, nil]
    #
    def caption
      first('caption')
    end

    # Returns true if this class represents the element for the given node
    #
    # @param node [Nokogiri::XML::Node] the underlying node
    # @return [Boolean]
    #
    def self.is_the_element_class_for?(node)
      node.name == 'table'
    end

  end
end
