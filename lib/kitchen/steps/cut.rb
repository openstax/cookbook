module Kitchen::Steps
  class Cut < Kitchen::Step
    def initialize(node:, to: :default)
      super(node: node)
      @to = to
    end

    def do_it
      node!.remove
      Kitchen::Clipboard.named(@to).add(node!)
    end
  end
end
