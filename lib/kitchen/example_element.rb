module Kitchen
  class ExampleElement < ElementBase

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
