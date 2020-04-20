module Kitchen::Steps
  class ReplaceChildren < Kitchen::Step
    def initialize(node:, with:)
      super(node: node)
      @with = with
    end

    def do_it
      if node!.class == Nokogiri::XML::Document
        raise Kitchen::RecipeError, "Cannot replace the children of the overall document -- pick an element, e.g.: " \
                                    "first!('body') { replace_children ... }"
      end

      node!.children = @with
    end
  end
end
