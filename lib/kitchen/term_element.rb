module Kitchen
  class TermElement < ElementBase

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: TermElementEnumerator,
            short_type: :term)
    end

  end
end
