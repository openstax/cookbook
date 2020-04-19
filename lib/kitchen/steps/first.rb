module Kitchen::Steps
  class First < Kitchen::Step
    def initialize(node:, selector:, raise_if_missing:, &block)
      if !block_given?
        raise Kitchen::RecipeError, "A `first` command must be given a block"
      end

      super(node: node)
      @selector = selector
      @block = block
    end

    def do_it
      first_node = node!.css(Kitchen::Selector.expand(@selector)).first

      if first_node.nil? && raise_if_missing
        raise "Could not find first element matching '#{@selector}'"
      end

      Basic.new(node: first_node, &@block).do_it
    end
  end
end
