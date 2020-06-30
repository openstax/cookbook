module Kitchen
  class TableElement < Element

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

  end
end
