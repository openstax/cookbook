module Kitchen
  class ElementEnumeratorFactory

    def self.within(new_enumerator_class:, element:,
                    css_or_xpath:, default_css_or_xpath:, sub_element_class:)
      # Apply the default css if needed
      css_or_xpath ||= "$"
      [css_or_xpath].flatten.each {|item| item.gsub!(/\$/, default_css_or_xpath) }

      new_enumerator_class.new do |block|
        grand_ancestors = element.ancestors

        # If the provided `css_or_xpath` has already been counted, we need to uncount
        # them on the ancestors so that when they are counted again below, the counts
        # are correct.
        if element.have_sub_elements_already_been_counted?(css_or_xpath)
          grand_ancestors.values.each do |ancestor|
            ancestor.decrement_descendant_count(
              sub_element_class.short_type,
              by: element.number_of_sub_elements_already_counted(css_or_xpath)
            )
          end
        end

        parent_ancestor = Ancestor.new(element)
        num_sub_elements = 0

        # TODO there's a confusing overlap between this code and element.search, like
        # anyone who uses element.search we want ancestry stuff there but it isn't happening
        # there
        element.search(css_or_xpath).each do |sub_element|
          # TODO pretty sure this just happend in the .search call above
          sub_element.document.location = sub_element

          sub_element = sub_element.is_a?(sub_element_class) ? sub_element : sub_element_class.new(element: sub_element)
          num_sub_elements += 1

          sub_element.add_ancestors(grand_ancestors, parent_ancestor)
          sub_element.count_as_descendant

          block.yield(sub_element)
        end

        element.remember_that_sub_elements_are_already_counted(
          css_or_xpath: css_or_xpath, count: num_sub_elements
        )
      end
    end

    def self.chained_to_other(other_enumerator:, new_enumerator_class:, css_or_xpath: nil)
      new_enumerator_class.new do |block|
        other_enumerator.each do |element|
          new_enumerator_class.within(element: element, css_or_xpath: css_or_xpath).each do |sub_element|
            block.yield(sub_element)
          end
        end
      end
    end

  end
end
