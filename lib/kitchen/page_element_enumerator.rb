module Kitchen
  class PageElementEnumerator < ElementEnumerator
    # def terms
    #   puts "Page.terms A"
    #   TermElementEnumerator.new do |block|
    #     puts "Page.terms B"
    #     self.each do |page|
    #       puts "Page.terms C"
    #       TermElementEnumerator.within(page).each do |t|
    #         puts "Page.terms D"
    #         block.yield(t)
    #       end
    #     end
    #   end
    # end

    def terms
      TermElementEnumerator.chained_to_enumerator(self)
    end

    # TermElementEnumerator.new(history) do |block| # ElementEnumerator initializer takes history
    #   self.each do |page| # override each to push page into history

    #   end
    # end

    def self.within(element:, iteration_history: nil, inside_chain: false)
      ElementEnumerator.within(enumerator_class: self,
                               element: element,
                               css_or_xpath: "div[data-type='page']",
                               sub_element_wrapper_class: PageElement,
                               inside_chain: inside_chain)
      # new(iteration_history: iteration_history) do |block|
      #   # TODO parent should provide page selector
      #   ancestor_for_element = Ancestor.new(element)


      #   element.each("div[data-type='page']") do |sub_element| # TODO make `each` open and close history levels
      #     page = PageElement.new(element: sub_element)

      #     page.add_ancestors(element.ancestors, ancestor_for_element)
      #     #*****
      #     #
      #     # When constructing PageElement, give it ancestors = element.ancestors + [element]
      #     # for each of those ancestors, call increment_child_count(:page)
      #     # store return value of that call in PageElement counts
      #     #
      #     # page.set_ancestors(element.ancestors + [element])
      #     #
      #     # class Element
      #     #   def set_ancestors(array)
      #     #     @ancestors = array.dup
      #     #     @ancestors.each do |ancestor|
      #     #       num_my_type_in_ancestor = ancestor.increment_child_count(iteration_history_name) # rename iteration_history
      #     #       set_number_in_ancestor(num_my_type_in_ancestor, ancestor.iteration_history_name)
      #     #     end
      #     #   end
      #     # end
      #     #
      #     # Need to make sure that counts aren't shared across different iterations, e.g.:
      #     #
      #     #   my_book.chapters
      #     #   my_book.chapters

      #     # iteration_history.record(page)


      #     block.yield(page)
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

          # TODO where to assign number_in

          # case parent
          # when ChapterElement
          #   page.chapter = parent
          #   page.unit = parent.unit
          #   page.book = parent.book
          # when BookDocument
          #   page.book = parent
          # end


  end
end
