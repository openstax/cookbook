module Kitchen
  class FigureElement < Element

    def self.short_type
      :figure
    end

    def initialize(node:, document: nil)
      super(node: node, document: document, short_type: self.class.short_type)
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
