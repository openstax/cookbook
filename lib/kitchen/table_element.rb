module Kitchen
  class TableElement < ElementBase

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: TableElementEnumerator,
            short_type: :table)
    end

    def title_row
      top_titled? ? first('thead').first('tr') : nil
    end

    def title
      title_row&.first('th').children
    end

    def top_titled?
      has_class?('top-titled')
    end

    def unnumbered?
      has_class?('unnumbered')
    end

    def self.is_the_element_class_for?(node)
      node.name == "table"
    end

  end
end
