module Kitchen
  class ExampleElement < Element

    def self.short_type
      :example
    end

    def initialize(element:)
      super(node: element.raw, document: element.document, short_type: self.class.short_type)
    end

    def titles
      elements("span[data-type='title']")
    end

    protected

    def as_enumerator
      ExampleElementEnumerator.new {|block| block.yield(self)}
    end

  end
end
