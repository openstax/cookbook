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

    def tables(css_or_xpath=nil, &block)
      chain_to(enumerator_class: TableElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def examples(css_or_xpath=nil, &block)
      ExampleElementEnumerator.factory.build_within(self, css_or_xpath: css_or_xpath)
      # chain_to(enumerator_class: ExampleElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def search(css_or_xpath=nil, &block)
      chain_to(enumerator_class: ElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def chain_to(enumerator_class:, css_or_xpath: nil, &block)
      raise(RecipeError, "Did you forget a `.each` call on this enumerator?") if block_given?

      enumerator_class.factory.build_within(self, css_or_xpath: css_or_xpath)
    end

    def first!(missing_message: nil)
      # TODO would be cool to record the CSS in the enumerator constructor so can say "no first blah" here
      first || raise(RecipeError, missing_message || "Could not return a first result")
    end

    # Removes enumerated elements from their parent and places them on the specified clipboard
    #
    # @param to [Symbol, String, Clipboard, nil] the name of the clipboard (or a Clipboard
    #   object) to cut to. String values are converted to symbols. If not provided, the
    #   elements are placed on a new clipboard.
    # @return [Clipboard] the clipboard
    #
    def cut(to: nil)
      to ||= Clipboard.new
      self.each do |element|
        element.cut(to: to)
      end
      to
    end

    # Makes a copy of the enumerated elements and places them on the specified clipboard.
    #
    # @param to [Symbol, String, Clipboard, nil] the name of the clipboard (or a Clipboard
    #   object) to copy to.  String values are converted to symbols.  If not provided, the
    #   copies are placed on a new clipboard.
    # @return [Clipboard] the clipboard
    #
    def copy(to: nil)
      to ||= Clipboard.new
      self.each do |element|
        element.copy(to: to)
      end
      to
    end

    def trash
      self.each(&:trash)
    end

    def [](index)
      to_a[index]
    end

    def to_s
      self.map(&:to_s).join("")
    end

    def self.factory
      ElementEnumeratorFactory.new(
        sub_element_class: Element,
        enumerator_class: self
      )
    end

  end
end
