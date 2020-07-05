module Kitchen
  class ElementEnumeratorFactory

    attr_reader :default_css_or_xpath
    attr_reader :enumerator_class
    attr_reader :sub_element_class

    def initialize(default_css_or_xpath: nil, sub_element_class:, enumerator_class:)
      @default_css_or_xpath = default_css_or_xpath
      @sub_element_class = sub_element_class
      @enumerator_class = enumerator_class
    end

    # TODO spec this!
    def apply_default_css_or_xpath_and_normalize(css_or_xpath=nil)
      css_or_xpath ||= "$"
      [css_or_xpath].flatten.each {|item| item.gsub!(/\$/, [default_css_or_xpath].flatten.join(", ")) }
      [css_or_xpath].flatten
    end

    def build_within(enumerator_or_element, css_or_xpath: nil)
      css_or_xpath = apply_default_css_or_xpath_and_normalize(css_or_xpath)

      case enumerator_or_element
      when ElementBase
        build_within_element(enumerator_or_element, css_or_xpath: css_or_xpath)
      when ElementEnumeratorBase
        build_within_other_enumerator(enumerator_or_element, css_or_xpath: css_or_xpath)
      end
    end

    protected

    def build_within_element(element, css_or_xpath:)
      enumerator_class.new(css_or_xpath: css_or_xpath) do |block|
        grand_ancestors = element.ancestors
        parent_ancestor = Ancestor.new(element)

        num_sub_elements = 0

        element.raw.search(*css_or_xpath).each_with_index do |sub_node, index|
          # All elements except for `Element` have a built-in `short_type`; for Element,
          # define a dynamic short type based on the search css/xpath.
          sub_element =
            sub_element_class == Element ?
              sub_element_class.new(node: sub_node,
                                    document: element.document,
                                    short_type: Utils.search_path_to_type(css_or_xpath)) :
              sub_element_class.new(node: sub_node,
                                    document: element.document)

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

          # Record this sub element's ancestors and increment their descendant counts
          sub_element.add_ancestors(grand_ancestors, parent_ancestor)
          sub_element.count_as_descendant

          # Remember how this sub element was found so can trace search history given
          # any element.
          sub_element.css_or_xpath_that_found_me = css_or_xpath

          # Count runs through this loop for below
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

    def build_within_other_enumerator(other_enumerator, css_or_xpath:)
      # Return a new enumerator instance that internally iterates over `other_enumerator`
      # running a new enumerator for each element returned by that other enumerator.
      enumerator_class.new(css_or_xpath: css_or_xpath, upstream_enumerator: other_enumerator) do |block|
        other_enumerator.each do |element|
          build_within_element(element, css_or_xpath: css_or_xpath).each do |sub_element|
            block.yield(sub_element)
          end
        end
      end
    end

  end
end
