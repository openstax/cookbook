module Kitchen
  class ExampleElement < Element

    def self.short_type
      :example
    end

    def initialize(node:, document: nil)
      super(node: node, document: document, short_type: self.class.short_type)
    end

    def titles
      search("span[data-type='title']")
    end

    protected

    def as_enumerator
      ExampleElementEnumerator.new {|block| block.yield(self)}
    end

  end
end
