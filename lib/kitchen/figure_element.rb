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

    def self.is_the_element_class_for?(node)
      node.name == "figure"
    end

  end
end
