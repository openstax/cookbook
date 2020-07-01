module Kitchen
  class ElementEnumeratorFactory

    def self.within(new_enumerator_class:, element:,
                    css_or_xpath:, default_css_or_xpath:, sub_element_class: Element)
      # Apply the default css if needed
      css_or_xpath ||= "$"
      [css_or_xpath].flatten.each {|item| item.gsub!(/\$/, [default_css_or_xpath].flatten.join(", ")) }
      [css_or_xpath].flatten! if css_or_xpath.is_a?(Array)

      new_enumerator_class.new do |block|
        grand_ancestors = element.ancestors
        parent_ancestor = Ancestor.new(element)

        num_sub_elements = 0

        element.raw.search(*css_or_xpath).each_with_index do |sub_node, index|
          # All elements except for `Element` have a built-in `short_type`; for Element,
          # define a dynamic short type based on the search css/xpath.
          sub_element =
            sub_element_class == Element ?
              sub_element_class.new(node: sub_node, document: element.document,
                                    short_type: Utils.search_path_to_type(css_or_xpath)) :
              sub_element_class.new(node: sub_node, document: element.document)


          # If the provided `css_or_xpath` has already been counted, we need to uncount
          # them on the ancestors so that when they are counted again below, the counts
          # are correct.  Only do this on the first loop!
          if index == 0
            if element.have_sub_elements_already_been_counted?(css_or_xpath)
              grand_ancestors.values.each do |ancestor|
                ancestor.decrement_descendant_count(
                  sub_element.short_type,
                  by: element.number_of_sub_elements_already_counted(css_or_xpath)
                )
              end
            end
          end

          sub_element.add_ancestors(grand_ancestors, parent_ancestor)
          sub_element.count_as_descendant

          num_sub_elements += 1

          # Mark the location so that if there's an error we can show the developer where.
          sub_element.document.location = sub_element

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
