module Kitchen
  class ElementEnumerator < Enumerator

    attr_reader :iteration_history

    def initialize(iteration_history: nil)
      @iteration_history || IterationHistory.new
      super(nil) # TODO is there a way to calculate the size lazily?
    end

    def cut
      clipboard = Clipboard.new
      self.each do |element|
        element.cut(to: clipboard)
      end
      clipboard
    end

    def counts
      @counts ||= {}
    end

    def [](index)
      to_a[index]
    end

    # TODO move to EnumeratorFactory & get last two args from enumerator_class?
    def self.within(enumerator_class:, element:, css_or_xpath:, sub_element_wrapper_class: nil, inside_chain:)
      enumerator_class.new(iteration_history: nil) do |block|
         # TODO need element.self_as_ancestor that is memoized?
        ancestor_for_element = Ancestor.new(element)
        # debugger
        # ancestors = inside_chain ? element.ancestors : element.cloned_ancestors
        ancestors = element.ancestors
        # debugger
        # ancestors.values.each{|ancestor| ancestor.reset_descendant_counts_except(ancestors.keys + [ancestor_for_element.type])}
        # count_descendants =

        sub_element_type = nil
        num_sub_elements = 0


        (ancestors.values).each do |ancestor|
          ancestor.decrement_descendant_count(sub_element_wrapper_class.short_type,
                                              by: element.number_of_subelements_already_counted(css_or_xpath))
        end

        element.each(css_or_xpath) do |sub_element|
          if sub_element_wrapper_class.present?
            sub_element = sub_element_wrapper_class.new(element: sub_element)
          end

          sub_element_type = sub_element.short_type
          num_sub_elements += 1

          sub_element.add_ancestors(ancestors, ancestor_for_element)
          sub_element.count_as_descendant #if !element.has_been_counted?(css_or_xpath)

          # ^^^ THIS `if` doesn't work b/c the second iteration we don't count at all
          # and we don't magically get a copy of the earlier counts
          # I wonder if instead we can undo the counts after this .each loop?

          block.yield(sub_element)
        end

        # (ancestors.values + [ancestor_for_element]).each do |ancestor|
        #   ancestor.decrement_descendant_count(sub_element_type, by: num_sub_elements)
        # end
        #
        # # ^^^ THIS DOESN"T work b/c in same cases we don't want to forget that we counted
        # # really we want to forget we counted only when we are about to count something
        # # on an element again that we already counted.  So can we cache on the `element`
        # # when we have already iterated on `css_or_xpath` and how many sub elements that
        # # resulted in.  Then the non-first times through we can decrement

        element.mark_counted(css_or_xpath: css_or_xpath, num_sub_elements: num_sub_elements)
      end
    end

    # TODO rename new_enumerator_chained_to_other(new_enumerator_class:, other_enumerator:)
    def self.chained_to_enumerator(enumerator_class:, chained_to:)
      iteration_history = chained_to.iteration_history

      enumerator_class.new(iteration_history: iteration_history) do |block|
        # debugger
        chained_to.each do |element|
          enumerator_class.within(element: element, inside_chain: true, iteration_history: iteration_history).each do |sub_element|
            block.yield(sub_element)
          end
        end
      end
    end

    # def each
    #   debugger
    #   debugger

    #   super
    # end


  end
end
