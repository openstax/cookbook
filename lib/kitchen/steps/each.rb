module Kitchen::Steps
  class Each < Kitchen::Step

    attr_reader :selector_or_xpath_args

    def initialize(node:, selector_or_xpath_args:, &block)
      raise "An `each` command must be given a block" if !block_given?

      super(node: node)
      @selector_or_xpath_args = selector_or_xpath_args
      @block = block
    end

    def do_it
      node!.search(*selector_or_xpath_args).each do |inner_node|
        Kitchen::Debug::DocumentCursor.current_node = inner_node
        Basic.new(node: inner_node, &@block).do_it
      end
    end
  end
end
