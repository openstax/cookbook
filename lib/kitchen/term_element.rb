module Kitchen
  class TermElement < Element

    def self.short_type
      :term
    end

    def initialize(element:)
      super(node: element.raw, document: element.document, short_type: self.class.short_type)
    end

    protected

    def as_enumerator
      TermElementEnumerator.new {|block| block.yield(self)}
    end

  end
end
