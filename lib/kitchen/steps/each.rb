module Kitchen::Steps
  class Each < Kitchen::Step
    def initialize(node:, selector:, &block)
      raise "An `each` command must be given a block" if !block_given?

      super(node: node)
      @selector = selector
      @block = block
    end

    def do_it
      node!.css(Kitchen::Selector.expand(@selector)).each do |inner_node|
        Basic.new(node: inner_node, &@block).do_it
      end
    end
  end
end
