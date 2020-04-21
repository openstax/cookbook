module Kitchen::Steps
  class PrependChild < Kitchen::Step
    def initialize(node:, child:)
      super(node: node)
      @child = child
    end

    def do_it
      if node!.class == Nokogiri::XML::Document
        raise Kitchen::RecipeError, "Cannot prepend a child on the overall document -- pick an element, e.g.: " \
                                    "first!('body') { prepend_child ... }"
      end

      if node!.children.empty?
        node!.children = @child.to_s
      else
        node!.children.first.add_previous_sibling(@child)
      end
    end
  end
end
