module Kitchen::Steps
  class AppendChild < Kitchen::Step
    def initialize(node:, child:)
      super(node: node)
      @child = child
    end

    def do_it
      if node!.class == Nokogiri::XML::Document
        raise Kitchen::RecipeError, "Cannot append a child on the overall document -- pick an element, e.g.: " \
                                    "first!('body') { append_child ... }"
      end

      node!.add_child(@child)
    end
  end
end
