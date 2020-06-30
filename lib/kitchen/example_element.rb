module Kitchen
  class ExampleElement < Element

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: ExampleElementEnumerator,
            short_type: :example)
    end

    def titles
      search("span[data-type='title']")
    end

  end
end
