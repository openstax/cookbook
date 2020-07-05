module Kitchen
  class ElementEnumerator < Enumerator

    def initialize(size=nil, css_or_xpath: nil, upstream_enumerator: nil)
      @css_or_xpath = css_or_xpath
      @upstream_enumerator = upstream_enumerator
      super(size)
    end

    def search_history
      (@upstream_enumerator&.search_history || SearchHistory.empty).add(@css_or_xpath)
    end

    def terms(css_or_xpath=nil, &block)
      chain_to(TermElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def pages(css_or_xpath=nil, &block)
      chain_to(PageElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def chapters(css_or_xpath=nil, &block)
      chain_to(ChapterElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    # use block_error_if
    def figures(css_or_xpath=nil, &block)
      chain_to(FigureElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def notes(css_or_xpath=nil, &block)
      chain_to(NoteElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def tables(css_or_xpath=nil, &block)
      chain_to(TableElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def examples(css_or_xpath=nil, &block)
      chain_to(ExampleElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def search(css_or_xpath=nil, &block)
      chain_to(ElementEnumerator, css_or_xpath: css_or_xpath, &block)
    end

    def chain_to(enumerator_class, css_or_xpath: nil, &block)
      raise(RecipeError, "Did you forget a `.each` call on this enumerator?") if block_given?

      enumerator_class.factory.build_within(self, css_or_xpath: css_or_xpath)
    end

    def first!(missing_message: "Could not return a first result")
      first || raise(RecipeError, "#{missing_message} matching #{search_history.latest} " \
                                  "inside #{search_history.upstream}")
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
