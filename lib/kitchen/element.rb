module Kitchen
  class Element < ElementBase

    def initialize(node:, document:, short_type: nil)
      super(node: node,
            document: document,
            enumerator_class: ElementEnumerator,
            short_type: short_type)
    end

    # # @!method pages
    # #   Returns a pages enumerator
    # def_delegators :as_enumerator, :pages, :chapters, :terms, :figures, :notes, :tables, :examples
  end
end
