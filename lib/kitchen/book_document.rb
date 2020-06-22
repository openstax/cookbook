module Kitchen
  class BookDocument < Document

    TERM_COUNTER_NAME = :book_term_counter

    # TODO store default selectors here and provide a method for overriding them
    # wonder if we should just write it out so YARD works
    # ACTUALLY make a Selectors class that has all of these defined, with defaults
    # and pass a (modified) instance into this class

    DEFAULT_SELECTORS = {
      page_title_selector: "*[data-type='document-title'][2]"
    }

    DEFAULT_SELECTORS.each do |name, value|
      attr_writer name

      define_method(name) do
        eval(%Q(@#{name} ||= "#{value}"))
      end
    end

    def initialize(document:, numbering_style: "1.1.1")
      @numbering_style = numbering_style # not used yet

      super(nokogiri_document: document.is_a?(Document) ? document.raw : document)

      @has_units = !first("div[data-type='unit']").nil?
      @css_or_xpath_that_has_been_counted = {}
    end

    def has_units?
      @has_units
    end

    # Iterates over all children in the book.  Also increments a `:chapter` counter,
    # resetting it at the start of the iteration.
    #
    # @yieldparam [Element] the matched XML element
    #
    def each_chapter # TODO provide as `each_chapter_with_count`

      # can we make each_chapter a mixin to both this class and UnitElement?
      raise(Kitchen::RecipeError, "An `each_chapter` command must be given a block") if !block_given?

      counter(ChapterElement::COUNTER_NAME).reset

      each("div[data-type='chapter']") do |element|
        chapter = ChapterElement.new(element: element)
        counter(ChapterElement::COUNTER_NAME).increment
        yield chapter, counter(ChapterElement::COUNTER_NAME).get
      end
    end

    def each_unit
      # ...
    end

    def number_html(counter_names)
      counts = counter_names.map { |counter_name| counter(counter_name).get }
      <<~HTML
        <span class="os-number">#{counts.join(".")}</span>
      HTML
    end

    # def title
    #   first("div[data-type='document-title']")
    # end

    def each_chapter_page  # is this useful?
      if has_units?
        each_unit do |unit|
          unit.each_chapter do |chapter|
            chapter.each_page do |page|
              yield page
            end
          end
        end
      else
        each_chapter do |chapter|
          chapter.each_page do |page|
            yield page
          end
        end
      end
    end

    def each_page
      # can we make each_chapter a mixin to both this class and UnitElement?
      raise(Kitchen::RecipeError, "An `each_page` command must be given a block") if !block_given?

      each("div[data-type='page']") do |element|
        page = PageElement.new(element: element, chapter: nil)
        yield page
      end
    end

    def each_term
      # TODO can we make each_term a mixin to both this class and ChapterElement and UnitElement?
      raise(Kitchen::RecipeError, "An `each_term` command must be given a block") if !block_given?

      counter(TERM_COUNTER_NAME).reset

      each_page do |page|
        page.each_term do |term|
          counter(TERM_COUNTER_NAME).increment
          yield term, counter(TERM_COUNTER_NAME).get
        end
      end
    end

    # TODO Can these methods move to Element (may not apply but who cares)

    def pages(css_or_xpath=nil)
      PageElementEnumerator.within(element_or_document: self, css_or_xpath: css_or_xpath)
    end

    def chapters
      ChapterElementEnumerator.within(element_or_document: self)
    end

    def terms
      TermElementEnumerator.within(element_or_document: self)
    end

    def ancestors
      {}
    end

    def cloned_ancestors
      {}
    end

    def remember_that_sub_elements_are_already_counted(css_or_xpath:, count:)
      @css_or_xpath_that_has_been_counted[css_or_xpath] = count
    end

    def have_sub_elements_already_been_counted?(css_or_xpath)
      number_of_sub_elements_already_counted(css_or_xpath) != 0
    end

    def number_of_sub_elements_already_counted(css_or_xpath)
      @css_or_xpath_that_has_been_counted[css_or_xpath] || 0
    end

    def short_type
      :book
    end

  end
end
