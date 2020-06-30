module Kitchen
  class TermElement < Element

    def self.short_type
      :term
    end

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: TermElementEnumerator,
            short_type: self.class.short_type)
    end

  end
end
