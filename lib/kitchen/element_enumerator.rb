module Kitchen
  class ElementEnumerator < Enumerator

    def terms(css_or_xpath=nil, &block)
      chain_to(enumerator_class: TermElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def pages(css_or_xpath=nil, &block)
      chain_to(enumerator_class: PageElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def chapters(css_or_xpath=nil, &block)
      chain_to(enumerator_class: ChapterElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    # use block_error_if
    def figures(css_or_xpath=nil, &block)
      chain_to(enumerator_class: FigureElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def notes(css_or_xpath=nil, &block)
      chain_to(enumerator_class: NoteElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def elements(*selector_or_xpath_args, &block)
      chain_to(enumerator_class: self.class, css_or_xpath: selector_or_xpath_args, &block)
    end

    def chain_to(enumerator_class:, css_or_xpath: nil, &block)
      raise(RecipeError, "Did you forget a `.each` call on this enumerator?") if block_given?

      ElementEnumeratorFactory.chained_to_other(new_enumerator_class: enumerator_class,
                                                other_enumerator: self,
                                                css_or_xpath: css_or_xpath)
    end

    def first!
      # TODO would be cool to record the CSS in the enumerator constructor so can say "no first blah" here
      first || raise(RecipeError, "Could not return a first result")
    end

    # TODO add (to: nil) argument so can specify a clipboard name
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

    def self.within(element:, css_or_xpath:)
      ElementEnumeratorFactory.within(new_enumerator_class: self,
                                      element: element,
                                      css_or_xpath: css_or_xpath,
                                      default_css_or_xpath: "*",
                                      sub_element_class: Element)
    end

  end
end
