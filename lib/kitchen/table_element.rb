module Kitchen
  class TableElement < Element

    def self.short_type
      :table
    end

    def initialize(element:)
      super(node: element.raw, document: element.document, short_type: self.class.short_type)
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

    protected

    def as_enumerator
      TableElementEnumerator.new {|block| block.yield(self)}
    end

  end
end
