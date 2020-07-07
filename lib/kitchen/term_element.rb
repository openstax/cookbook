module Kitchen
  class TermElement < ElementBase

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: TermElementEnumerator,
            short_type: :term)
    end

    def self.is_the_element_class_for?(node)
      node['data-type'] == "term"
    end

  end
end
