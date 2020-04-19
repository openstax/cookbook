module Kitchen::Steps
  class Copy < Kitchen::Step
    def initialize(node:, to: :default, &block)
      super(node: node)
      @to = to
      @block = block
    end

    def do_it
      the_copy = node!.clone
      Basic.new(node: the_copy, &block).do_it
      Kitchen::Clipboard.named(@to).add(the_copy)
    end
  end
end
