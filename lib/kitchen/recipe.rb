module Kitchen
  class Recipe

    attr_reader :document
    attr_reader :source_location

    def document=(document)
      @document =
        case document
        when Kitchen::Document
          document
        when Nokogiri::XML::Document
          Kitchen::Document.new(nokogiri_document: document)
        end
    end

    # Make a new Recipe
    #
    # @yieldparam doc [Document] an object representing an XML document
    #
    def initialize(&block)
      @source_location = block.source_location[0]
      @block = block
    end

    def node!
      node || raise("The recipe's node has not been set")
    end

    def bake
      begin
        @block.to_proc.call(document)
      rescue RecipeError => ee
        print_recipe_error_and_exit(ee)
      rescue ArgumentError => ee
        if if_any_stack_file_matches_source_location?(ee)
          print_recipe_error_and_exit(ee)
        else
          raise
        end
      rescue NoMethodError => ee
        if if_any_stack_file_matches_source_location?(ee)
          print_recipe_error_and_exit(ee)
        else
          raise
        end
      rescue NameError => ee
        if if_stack_starts_with_source_location?(ee)
          print_recipe_error_and_exit(ee)
        else
          raise
        end
      rescue ElementNotFoundError => ee
        print_recipe_error_and_exit(ee)
      rescue Nokogiri::CSS::SyntaxError => ee
        print_recipe_error_and_exit(ee)
      end
    end

    protected

    def if_stack_starts_with_source_location?(error)
      error.backtrace.first.start_with?(source_location)
    end

    def if_any_stack_file_matches_source_location?(error)
      error.backtrace.any? {|entry| entry.start_with?(@source_location)}
    end

    def print_recipe_error_and_exit(error)
      Kitchen::Debug.print_recipe_error(error: error,
                                        source_location: source_location,
                                        document: document)
      exit(1)
    end

  end
end
