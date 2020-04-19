module Kitchen::Steps
  class AppendChild < Kitchen::Step
    def initialize(node:, child:)
      super(node: node)
      @child = child
    end

    def do_it
      node!.add_child(@child)
    end
  end
end
