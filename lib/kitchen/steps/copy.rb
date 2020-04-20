module Kitchen::Steps
  class Copy < Kitchen::Step
    def initialize(node:, to: :default, &block)
      super(node: node)
      @to = to
      @block = block_given? ? block : nil
    end

    def do_it
      the_copy = node!.clone
      Basic.new(node: the_copy, &@block).do_it if !@block.nil?
      Kitchen::Clipboard.named(@to).add(the_copy)
    end
  end
end
