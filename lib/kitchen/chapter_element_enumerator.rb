module Kitchen
  class ChapterElementEnumerator < ElementEnumerator

    def pages
      PageElementEnumerator.chained_to_enumerator(self)
    end

    def self.within(element:, iteration_history: nil, inside_chain: false)
      ElementEnumerator.within(enumerator_class: self,
                               element: element,
                               css_or_xpath: "div[data-type='chapter']",
                               sub_element_wrapper_class: ChapterElement,
                               inside_chain: inside_chain)
      # new(iteration_history: iteration_history) do |block|
      #   ancestor_for_element = Ancestor.new(element)

      #   element.each("div[data-type='chapter']") do |sub_element|
      #     chapter = ChapterElement.new(element: sub_element)
      #     chapter.add_ancestors(element.ancestors, ancestor_for_element) # TODO need element.self_as_ancestor that is memoized?
      #     block.yield(chapter)
      #   end
      # end
    end

    def self.chained_to_enumerator(other_enumerator)
      ElementEnumerator.chained_to_enumerator(enumerator_class: self,
                                              chained_to: other_enumerator)
      # iteration_history = other_enumerator.iteration_history

      # new(iteration_history: iteration_history) do |block|
      #   other_enumerator.each do |element| # TODO this can be a method on base class
      #     within(element: element, iteration_history: iteration_history).each do |chapter|
      #       block.yield(chapter)
      #     end
      #   end
      # end
    end

  end
end
