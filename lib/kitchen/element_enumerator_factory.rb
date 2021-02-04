# frozen_string_literal: true

module Kitchen
  # Builds specific subclasses of ElementEnumeratorBase
  #
  class ElementEnumeratorFactory

    attr_reader :default_css_or_xpath
    attr_reader :enumerator_class
    attr_reader :sub_element_class
    attr_reader :detect_sub_element_class

    # Creates a new instance
    #
    # @param default_css_or_xpath [String] The selectors to substitute for the "$" character
    #   when this factory is used to build an enumerator.
    # @param sub_element_class [ElementBase] The element class to use for what the enumerator finds.
    # @param enumerator_class [ElementEnumeratorBase] The enumerator class to return
    # @param detect_sub_element_class [Boolean] If true, infers the sub_element_class from the node
    #
    def initialize(enumerator_class:, default_css_or_xpath: nil, sub_element_class: nil,
                   detect_sub_element_class: false)
      @default_css_or_xpath = default_css_or_xpath
      @sub_element_class = sub_element_class
      @enumerator_class = enumerator_class
      @detect_sub_element_class = detect_sub_element_class
    end

    # Builds a new enumerator within the scope of the provided argument (either
    # an enumerator or a class).  Accepts optional selectors to further limit
    # the scope of results found.
    #
    # @param enumerator_or_element [ElementEnumeratorBase, ElementBase] the object
    #   within which to iterate
    # @param css_or_xpath [String, Array<String>] selectors to use to limit iteration
    #   results
    # @return [ElementEnumeratorBase] actually returns the concrete enumerator class
    #   given to the factory in its constructor.
    #
    def build_within(enumerator_or_element, css_or_xpath: nil)
      css_or_xpath = self.class.apply_default_css_or_xpath_and_normalize(
        css_or_xpath: css_or_xpath,
        default_css_or_xpath: default_css_or_xpath
      )

      case enumerator_or_element
      when ElementBase
        build_within_element(enumerator_or_element, css_or_xpath: css_or_xpath)
      when ElementEnumeratorBase
        build_within_other_enumerator(enumerator_or_element, css_or_xpath: css_or_xpath)
      end
    end

    # Builds a new enumerator that finds elements matching either this factory's or the provided
    # factory's selectors.
    #
    # @param other_factory [ElementEnumeratorFactory]
    # @return [ElementEnumeratorFactory]
    #
    def or_with(other_factory)
      self.class.new(
        default_css_or_xpath: "#{default_css_or_xpath}, #{other_factory.default_css_or_xpath}",
        enumerator_class: TypeCastingElementEnumerator,
        detect_sub_element_class: true
      )
    end

    def self.apply_default_css_or_xpath_and_normalize(css_or_xpath: nil, default_css_or_xpath: nil)
      [css_or_xpath || '$'].flatten.map do |item|
        item.gsub(/\$/, [default_css_or_xpath].flatten.join(', '))
      end
    end

    protected

    def build_within_element(element, css_or_xpath:)
      enumerator_class.new(css_or_xpath: css_or_xpath) do |block|
        grand_ancestors = element.ancestors
        parent_ancestor = Ancestor.new(element)

        num_sub_elements = 0

        element.raw.search(*css_or_xpath).each_with_index do |sub_node, index|
          sub_element = ElementFactory.build_from_node(
            node: sub_node,
            document: element.document,
            element_class: sub_element_class,
            default_short_type: Utils.search_path_to_type(css_or_xpath),
            detect_element_class: detect_sub_element_class
          )

          # If the provided `css_or_xpath` has already been counted, we need to uncount
          # them on the ancestors so that when they are counted again below, the counts
          # are correct.  Only do this on the first loop!
          if index.zero? && element.have_sub_elements_already_been_counted?(css_or_xpath)
            grand_ancestors.each_value do |ancestor|
              ancestor.decrement_descendant_count(
                sub_element.short_type,
                by: element.number_of_sub_elements_already_counted(css_or_xpath)
              )
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
      enumerator_class.new(css_or_xpath: css_or_xpath,
                           upstream_enumerator: other_enumerator) do |block|
        other_enumerator.each do |element|
          build_within_element(element, css_or_xpath: css_or_xpath).each do |sub_element|
            block.yield(sub_element)
          end
        end
      end
    end

  end
end
