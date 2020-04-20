module Kitchen
  class Recipe

    attr_accessor :node
    attr_reader :source_location

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
        Kitchen::Debug.print_recipe_error(error: ee,
                                          source_location: source_location)
        exit(1)
      rescue ArgumentError => ee
        if if_any_stack_file_matches_source_location?(ee)
          Kitchen::Debug.print_recipe_error(error: ee,
                                            source_location: source_location)
          exit(1)
        else
          raise
        end
      rescue NameError => ee
        if if_stack_starts_with_source_location?(ee)
          Kitchen::Debug.print_recipe_error(error: ee,
                                            source_location: source_location)
          exit(1)
        else
          raise
        end
      rescue ElementNotFoundError => ee
        Kitchen::Debug.print_recipe_error(error: ee,
                                          source_location: source_location)
        exit(1)
      end
    end

    protected

    def if_stack_starts_with_source_location?(error)
      error.backtrace.first.start_with?(source_location)
    end

    def if_any_stack_file_matches_source_location?(error)
      error.backtrace.any? {|entry| entry.start_with?(@source_location)}
    end

  end
end
