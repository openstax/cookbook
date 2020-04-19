module Kitchen::Steps
  class Basic < Kitchen::Step
    def initialize(node:, &block)
      super(node: node)
      @block = block
    end

    def do_it
      instance_exec node, &@block
    end
  end
end
