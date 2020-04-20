module Kitchen::Steps
  class First < Kitchen::Step

    attr_reader :selector_or_xpath_args, :raise_if_missing

    def initialize(node:, selector_or_xpath_args:, raise_if_missing:, &block)
      if !block_given?
        raise Kitchen::RecipeError, "A `first` command must be given a block"
      end

      super(node: node)
      @selector_or_xpath_args = selector_or_xpath_args
      @raise_if_missing = raise_if_missing
      @block = block
    end

    def do_it
      first_node = node!.search(*selector_or_xpath_args).first

      if first_node.nil?
        if raise_if_missing
          raise Kitchen::ElementNotFoundError,
                "Could not find first element matching '#{selector_or_xpath_args}'"
        end
      else
        Basic.new(node: first_node, &@block).do_it
      end
    end
  end
end
