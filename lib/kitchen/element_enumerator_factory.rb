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
    # @param search_query [SearchQuery] search directives to limit iteration results
    # @return [ElementEnumeratorBase] actually returns the concrete enumerator class
    #   given to the factory in its constructor.
    #
    def build_within(enumerator_or_element, search_query: SearchQuery.new)
      search_query.apply_default_css_or_xpath_and_normalize(default_css_or_xpath)

      case enumerator_or_element
      when ElementBase
        build_within_element(enumerator_or_element, search_query: search_query)
      when ElementEnumeratorBase
        build_within_other_enumerator(enumerator_or_element, search_query: search_query)
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

    protected

    def build_within_element(element, search_query:)
      enumerator_class.new(search_query: search_query) do |block|
        grand_ancestors = element.ancestors
        parent_ancestor = Ancestor.new(element)

        # If the provided `search_query` has already been iterated through on this element,
        # we need to undo any counting on the ancestors so that when they are counted again
        # below, the counts are correct.
        element.uncount(search_query)

        element.raw.search(*search_query.css_or_xpath).each do |sub_node|
          sub_element = ElementFactory.build_from_node(
            node: sub_node,
            document: element.document,
            element_class: sub_element_class,
            default_short_type: search_query.as_type,
            detect_element_class: detect_sub_element_class
          )

          next unless search_query.conditions_match?(sub_element)

          # Record this sub element's ancestors and increment their descendant counts
          sub_element.add_ancestors(grand_ancestors, parent_ancestor)

          # Remember that we counted this sub element in case we need to later reset the counts
          element.remember_that_a_sub_element_was_counted(search_query, sub_element.short_type)

          # Remember how this sub element was found so can trace search history given any element.
          sub_element.search_query_that_found_me = search_query

          # Mark the location so that if there's an error we can show the developer where.
          sub_element.mark_as_current_location!

          block.yield(sub_element)
        end
      end
    end

    def build_within_other_enumerator(other_enumerator, search_query:)
      # Return a new enumerator instance that internally iterates over `other_enumerator`
      # running a new enumerator for each element returned by that other enumerator.
      enumerator_class.new(search_query: search_query,
                           upstream_enumerator: other_enumerator) do |block|
        other_enumerator.each do |element|
          build_within_element(element, search_query: search_query).each do |sub_element|
            block.yield(sub_element)
          end
        end
      end
    end

  end
end
