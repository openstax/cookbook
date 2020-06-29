module Kitchen
  class BookElement < Element

    def self.short_type
      :book
    end

    def initialize(node:, document: nil)
      super(node: node, document: document, short_type: self.class.short_type)
    end

    def metadata
      first!("div[data-type='metadata']")
    end

    def toc
      first!("nav#toc")
    end

    protected

    def as_enumerator
      BookElementEnumerator.new {|block| block.yield(self)}
    end

  end
end
