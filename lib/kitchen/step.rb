module Kitchen
  class Step

    def initialize(node:)
      @node = node
    end

    def each(selector, &block)
      Steps::Each.new(node: node!, selector: selector, &block).do_it
    end

    def first(selector, &block)
      Steps::First.new(node: node!, selector: selector,
                       raise_if_missing: false, &block).do_it
    end

    def first!(selector, &block)
      Steps::First.new(node: node!, selector: selector,
                       raise_if_missing: true, &block).do_it
    end

    def cut(to: :default)
      Steps::Cut.new(node: node!, to: to).do_it
    end

    def copy(to: :default, &block)
      Steps::Copy.new(node: node!, to: to, &block).do_it
    end

    def paste(from: :default)
      Kitchen::Clipboard.named(from).paste
    end

    def trash
      node!.remove
    end

    def append_child(child:)
      Steps::AppendChild.new(node: node!, child: child).do_it
    end

    protected

    attr_reader :node

    def node!
      node || raise("node is requested but not available")
    end

  end
end
