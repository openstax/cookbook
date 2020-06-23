module Kitchen
  class BookElement < Element

    def self.short_type
      :book
    end

    def initialize(element:)
      super(node: element.raw, document: element.document, short_type: self.class.short_type)
    end

    protected

    def as_enumerator
      BookElementEnumerator.new {|block| block.yield(self)}
    end

  end
end
