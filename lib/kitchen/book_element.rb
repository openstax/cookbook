module Kitchen
  class BookElement < ElementBase

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: BookElementEnumerator,
            short_type: :book)
    end

    def metadata
      first!("div[data-type='metadata']")
    end

    def toc
      first!("nav#toc")
    end

  end
end
