module Kitchen
  class FigureElement < Element

    def self.short_type
      :figure
    end

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: FigureElementEnumerator,
            short_type: self.class.short_type)
    end

    def caption
      first("figcaption")
    end

  end
end
