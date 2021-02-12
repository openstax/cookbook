# frozen_string_literal: true

module Kitchen
  # Base class for all element enumerators
  #
  class ElementEnumeratorBase < Enumerator
    include Mixins::BlockErrorIf

    # Creates a new instance
    #
    # @param size [Integer, Proc] How to calculate the size lazily, either a value
    #   or a callable object
    # @param css_or_xpath [String] the selectors this enumerator uses to search through
    #   the document
    # @param upstream_enumerator [ElementEnumeratorBase] the enumerator to which this
    #   enumerator is chained, used to access the upstream search history
    #
    def initialize(size=nil, css_or_xpath: nil, upstream_enumerator: nil)
      @css_or_xpath = css_or_xpath
      @upstream_enumerator = upstream_enumerator
      super(size)
    end

    # Return the search history based on this enumerator and any upstream enumerators
    #
    # @return [SearchHistory]
    #
    def search_history
      (@upstream_enumerator&.search_history || SearchHistory.empty).add(@css_or_xpath)
    end

    # Returns an enumerator that iterates through terms within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    #
    def terms(css_or_xpath=nil)
      block_error_if(block_given?)
      chain_to(TermElementEnumerator, css_or_xpath: css_or_xpath)
    end

    # Returns an enumerator that iterates through pages within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    #
    def pages(css_or_xpath=nil)
      block_error_if(block_given?)
      chain_to(PageElementEnumerator, css_or_xpath: css_or_xpath)
    end

    # Returns an enumerator that iterates through chapters within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    #
    def chapters(css_or_xpath=nil)
      block_error_if(block_given?)
      chain_to(ChapterElementEnumerator, css_or_xpath: css_or_xpath)
    end

    # Returns an enumerator that iterates through figures within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    #
    def figures(css_or_xpath=nil)
      block_error_if(block_given?)
      chain_to(FigureElementEnumerator, css_or_xpath: css_or_xpath)
    end

    # Returns an enumerator that iterates through notes within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    #
    def notes(css_or_xpath=nil)
      block_error_if(block_given?)
      chain_to(NoteElementEnumerator, css_or_xpath: css_or_xpath)
    end

    # Returns an enumerator that iterates through tables within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    #
    def tables(css_or_xpath=nil)
      block_error_if(block_given?)
      chain_to(TableElementEnumerator, css_or_xpath: css_or_xpath)
    end

    # Returns an enumerator that iterates through examples within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    #
    def examples(css_or_xpath=nil)
      block_error_if(block_given?)
      chain_to(ExampleElementEnumerator, css_or_xpath: css_or_xpath)
    end

    # Returns an enumerator that iterates through metadata within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    #
    def metadatas(css_or_xpath=nil)
      block_error_if(block_given?)
      chain_to(MetadataElementEnumerator, css_or_xpath: css_or_xpath)
    end

    # Returns an enumerator that iterates within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over
    #
    def search(css_or_xpath=nil)
      block_error_if(block_given?)
      chain_to(ElementEnumerator, css_or_xpath: css_or_xpath)
    end

    # Returns an enumerator that iterates through elements within the scope of this enumerator
    #
    # @param enumerator_class [ElementEnumeratorBase] the enumerator to use for the iteration
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over
    #
    def chain_to(enumerator_class, css_or_xpath: nil)
      block_error_if(block_given?)
      enumerator_class.factory.build_within(self, css_or_xpath: css_or_xpath)
    end

    # Returns the first element in this enumerator
    #
    # @param missing_message [String] the message to raise if a first element isn't available
    # @raise [RecipeError] if a first element isn't available
    # @return [Element]
    #
    def first!(missing_message: 'Could not return a first result')
      first || raise(RecipeError, "#{missing_message} matching #{search_history.latest} " \
                                  "inside [#{search_history.upstream}]")
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
      each do |element|
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
      each do |element|
        element.copy(to: to)
      end
      to
    end

    # Removes all matching elements from the document
    #
    def trash
      each(&:trash)
    end

    # Returns the element at the provided index
    #
    # @param index [Integer]
    # @return [Element]
    #
    def [](index)
      to_a[index]
    end

    # Returns a concatenation of +to_s+ for all elements in the enumerator
    #
    # @return [String]
    #
    def to_s
      map(&:to_s).join('')
    end

  end
end
