module Kitchen
  class FigureElement < Element

    def self.short_type
      :figure
    end

    def initialize(element:)
      super(node: element.raw, document: element.document, short_type: self.class.short_type)
    end

    def caption
      first("figcaption")
    end

    protected

    def as_enumerator
      FigureElementEnumerator.new {|block| block.yield(self)}
    end

  end
end
