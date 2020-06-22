module Kitchen
  class ElementEnumerator < Enumerator

    def cut
      clipboard = Clipboard.new
      self.each do |element|
        element.cut(to: clipboard)
      end
      clipboard
    end

    def [](index)
      to_a[index]
    end

    def elements(*selector_or_xpath_args)
      ElementEnumerator.chained_to_enumerator(self, css_or_xpath: selector_or_xpath_args)
    end


    def self.within(element_or_document:, css_or_xpath:)
      ElementEnumeratorFactory.within(new_enumerator_class: self,
                                      element_or_document: element_or_document,
                                      css_or_xpath: css_or_xpath,
                                      default_css_or_xpath: "*",
                                      sub_element_class: Element)
    end

    def self.chained_to_enumerator(other_enumerator, css_or_xpath:)
      ElementEnumeratorFactory.chained_to_other(new_enumerator_class: self,
                                                other_enumerator: other_enumerator,
                                                css_or_xpath: css_or_xpath)
    end

    def chain_to(enumerator_class:, css_or_xpath: nil, &block)
      raise(RecipeError, "Did you forget a `.each` call on this enumerator?") if block_given?

      ElementEnumeratorFactory.chained_to_other(new_enumerator_class: enumerator_class,
                                                other_enumerator: self,
                                                css_or_xpath: css_or_xpath)
    end

    # # TODO move to EnumeratorFactory & get last two args from enumerator_class?
    # def self.within(enumerator_class:, element:, css_or_xpath:, sub_element_wrapper_class: nil)
    #   enumerator_class.new do |block|
    #     grand_ancestors = element.ancestors

    #     # If the provided `css_or_xpath` has already been counted, we need to uncount
    #     # them on the ancestors so that when they are counted again below, the counts
    #     # are correct.
    #     if element.have_sub_elements_already_been_counted?(css_or_xpath)
    #       grand_ancestors.values.each do |ancestor|
    #         ancestor.decrement_descendant_count(
    #           sub_element_wrapper_class.short_type,
    #           by: element.number_of_sub_elements_already_counted(css_or_xpath)
    #         )
    #       end
    #     end

    #      # TODO need element.self_as_ancestor that is memoized?
    #     parent_ancestor = Ancestor.new(element)
    #     num_sub_elements = 0

    #     element.each(css_or_xpath) do |sub_element|
    #       num_sub_elements += 1

    #       if sub_element_wrapper_class.present?
    #         sub_element = sub_element_wrapper_class.new(element: sub_element)
    #       end

    #       sub_element.add_ancestors(grand_ancestors, parent_ancestor)
    #       sub_element.count_as_descendant

    #       block.yield(sub_element)
    #     end

    #     element.remember_that_sub_elements_are_already_counted(
    #       css_or_xpath: css_or_xpath, count: num_sub_elements
    #     )
    #   end
    # end

    # # TODO rename new_enumerator_chained_to_other(new_enumerator_class:, other_enumerator:)
    # def self.chained_to_enumerator(enumerator_class:, chained_to:)
    #   enumerator_class.new do |block|
    #     chained_to.each do |element|
    #       enumerator_class.within(element: element).each do |sub_element|
    #         block.yield(sub_element)
    #       end
    #     end
    #   end
    # end

  end
end
