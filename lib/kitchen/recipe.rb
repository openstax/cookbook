module Kitchen
  class Recipe

    attr_accessor :node

    def initialize(&block)
      @source_location = block.source_location[0]
      @block = block
    end

    def node!
      node || raise("The recipe's node has not been set")
    end

    def bake
      begin
        Steps::Basic.new(node: node!, &@block).do_it
      rescue RecipeError => ee
        ee.print(source_location: @source_location)
        exit(1)
      end
    end

  end
end
