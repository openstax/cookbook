module Kitchen
  class FigureElement < ElementBase

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: FigureElementEnumerator,
            short_type: :figure)
    end

    def caption
      first("figcaption")
    end

  end
end
