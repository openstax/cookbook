module Kitchen
  class TermElementEnumerator < ElementEnumerator

    def initialize(iteration_history:)
      super(iteration_history: iteration_history)
    end

    def self.within(element:, iteration_history: nil, inside_chain: false)
      ElementEnumerator.within(enumerator_class: self,
                               element: element,
                               css_or_xpath: "span[data-type='term']",
                               sub_element_wrapper_class: TermElement,
                               inside_chain: inside_chain)
      # new(iteration_history: iteration_history) do |block|
      #   ancestor_for_element = Ancestor.new(element)
      #   element.each("span[data-type='term']") do |sub_element|
      #     term = TermElement.new(element: sub_element)
      #     term.add_ancestors(element.ancestors, ancestor_for_element)

      #     # case parent
      #     # when PageElement
      #     #   term.page = parent
      #     #   term.chapter = parent.chapter
      #     #   term.book = parent.book
      #     # when BookDocument
      #     #   term.book = parent
      #     # end

      #     block.yield(term)
      #   end
      # end
    end

    def self.chained_to_enumerator(other_enumerator)
      ElementEnumerator.chained_to_enumerator(enumerator_class: self,
                                              chained_to: other_enumerator)
      # iteration_history = other_enumerator.iteration_history

      # new(iteration_history: iteration_history) do |block|
      #   other_enumerator.each do |element| # TODO this can be a method on base class
      #     within(element: element, iteration_history: iteration_history).each do |term|
      #       block.yield(term)
      #     end
      #   end
      # end
    end

  end
end
