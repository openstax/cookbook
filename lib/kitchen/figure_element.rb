module Kitchen
  class FigureElement < Element

    def initialize(element:)
      super(node: element.raw, document: element.document)
    end

    def caption
      first("figcaption")
    end

  end
end
