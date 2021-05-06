# frozen_string_literal: true

module Kitchen
  # Base class for all element enumerators
  #
  class ElementEnumeratorBase < Enumerator
    include Mixins::BlockErrorIf

    # Return the selectors or other search strings that this enumerator uses to
    # search through the document
    #
    # @return [String]
    #
    attr_reader :search_query

    # Creates a new instance
    #
    # @param size [Integer, Proc] How to calculate the size lazily, either a value
    #   or a callable object
    # @param search_query [String] the selectors or other search strings that this
    #   enumerator uses to search through the document
    # @param upstream_enumerator [ElementEnumeratorBase] the enumerator to which this
    #   enumerator is chained, used to access the upstream search history
    #
    def initialize(size=nil, search_query: nil, upstream_enumerator: nil)
      @search_query = search_query
      @upstream_enumerator = upstream_enumerator
      super(size)
    end

    # Return the search history based on this enumerator and any upstream enumerators
    #
    # @return [SearchHistory]
    #
    def search_history
      (@upstream_enumerator&.search_history || SearchHistory.empty).add(@search_query)
    end

    # Returns an enumerator that iterates through terms within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def terms(css_or_xpath=nil, only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(TermElementEnumerator, css_or_xpath: css_or_xpath, only: only, except: except)
    end

    # Returns an enumerator that iterates through pages within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def pages(css_or_xpath=nil, only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(PageElementEnumerator, css_or_xpath: css_or_xpath, only: only, except: except)
    end

    # Returns an enumerator that iterates through composite pages within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def composite_pages(css_or_xpath=nil, only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(CompositePageElementEnumerator, css_or_xpath: css_or_xpath, only: only, except: except)
    end

    # Returns an enumerator that iterates through pages that arent the introduction page within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    #
    def non_introduction_pages(only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(PageElementEnumerator,
               css_or_xpath: '$:not(.introduction)',
               only: only,
               except: except)
    end

    # Returns an enumerator that iterates through chapters within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def chapters(css_or_xpath=nil, only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(ChapterElementEnumerator, css_or_xpath: css_or_xpath, only: only, except: except)
    end

    # Returns an enumerator that iterates through units within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    #
    def units(css_or_xpath=nil, only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(UnitElementEnumerator, css_or_xpath: css_or_xpath, only: only, except: except)
    end

    # Returns an enumerator that iterates through figures within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def figures(css_or_xpath=nil, only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(FigureElementEnumerator, css_or_xpath: css_or_xpath, only: only, except: except)
    end

    # Returns an enumerator that iterates through notes within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def notes(css_or_xpath=nil, only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(NoteElementEnumerator, css_or_xpath: css_or_xpath, only: only, except: except)
    end

    # Returns an enumerator that iterates through tables within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def tables(css_or_xpath=nil, only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(TableElementEnumerator, css_or_xpath: css_or_xpath, only: only, except: except)
    end

    # Returns an enumerator that iterates through examples within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def examples(css_or_xpath=nil, only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(ExampleElementEnumerator, css_or_xpath: css_or_xpath, only: only, except: except)
    end

    # Returns an enumerator that iterates through titles within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def titles(css_or_xpath=nil, only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(ElementEnumerator,
               default_css_or_xpath: '[data-type="title"]',
               css_or_xpath: css_or_xpath,
               only: only,
               except: except)
    end

    # Returns an enumerator that iterates through references within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    #
    def references(css_or_xpath=nil)
      block_error_if(block_given?)
      chain_to(ReferenceElementEnumerator, css_or_xpath: css_or_xpath)
    end

    # Returns an enumerator that iterates through exercises within the scope of this enumerator
    #
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def exercises(css_or_xpath=nil, only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(ExerciseElementEnumerator, css_or_xpath: css_or_xpath, only: only, except: except)
    end

    # Returns an enumerator that iterates through metadata within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over;
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def metadatas(css_or_xpath=nil, only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(MetadataElementEnumerator, css_or_xpath: css_or_xpath, only: only, except: except)
    end

    # Returns an enumerator that iterates within the scope of this enumerator
    #
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over
    #
    def search(css_or_xpath=nil, only: nil, except: nil)
      block_error_if(block_given?)
      chain_to(ElementEnumerator, css_or_xpath: css_or_xpath, only: only, except: except)
    end

    # Returns an enumerator that iterates through elements within the scope of this enumerator
    #
    # @param enumerator_class [ElementEnumeratorBase] the enumerator to use for the iteration
    # @param default_css_or_xpath [String] the default CSS or xpath to use when iterating.  Normally,
    #   this value is provided by the `enumerator_class`, but that isn't always the case, e.g.
    #   when that class is a generic `ElementEnumerator`.
    # @param css_or_xpath [String] additional selectors to further narrow the element iterated over
    #   a "$" in this argument will be replaced with the default selector for the element being
    #   iterated over.
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    #
    def chain_to(enumerator_class, default_css_or_xpath: nil, css_or_xpath: nil,
                 only: nil, except: nil)
      block_error_if(block_given?)

      search_query = SearchQuery.new(
        css_or_xpath: css_or_xpath,
        only: only,
        except: except
      )

      if default_css_or_xpath
        search_query.apply_default_css_or_xpath_and_normalize(default_css_or_xpath)
      end

      enumerator_class.factory.build_within(self, search_query: search_query)
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
