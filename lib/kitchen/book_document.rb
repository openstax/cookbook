module Kitchen
  class BookDocument < Document

    attr_reader :short_name

    # TERM_COUNTER_NAME = :book_term_counter

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

    def initialize(document:, short_name: :not_set, numbering_style: "1.1.1")
      @numbering_style = numbering_style # not used yet

      super(nokogiri_document: document.is_a?(Document) ? document.raw : document)

      @short_name = short_name
      # @css_or_xpath_that_has_been_counted = {}
    end

    def book
      BookElement.new(element: search("html").first!)
    end

    # # Iterates over all children in the book.  Also increments a `:chapter` counter,
    # # resetting it at the start of the iteration.
    # #
    # # @yieldparam [Element] the matched XML element
    # #
    # def each_chapter # TODO provide as `each_chapter_with_count`

    #   # can we make each_chapter a mixin to both this class and UnitElement?
    #   raise(Kitchen::RecipeError, "An `each_chapter` command must be given a block") if !block_given?

    #   counter(ChapterElement::COUNTER_NAME).reset

    #   each("div[data-type='chapter']") do |element|
    #     chapter = ChapterElement.new(element: element)
    #     counter(ChapterElement::COUNTER_NAME).increment
    #     yield chapter, counter(ChapterElement::COUNTER_NAME).get
    #   end
    # end

    # def each_unit
    #   # ...
    # end

    # def number_html(counter_names)
    #   counts = counter_names.map { |counter_name| counter(counter_name).get }
    #   <<~HTML
    #     <span class="os-number">#{counts.join(".")}</span>
    #   HTML
    # end

    # def title
    #   first("div[data-type='document-title']")
    # end

    # TODO Can these methods move to Element (may not apply but who cares)

    # def ancestors
    #   {}
    # end

    # def remember_that_sub_elements_are_already_counted(css_or_xpath:, count:)
    #   @css_or_xpath_that_has_been_counted[css_or_xpath] = count
    # end

    # def have_sub_elements_already_been_counted?(css_or_xpath)
    #   number_of_sub_elements_already_counted(css_or_xpath) != 0
    # end

    # def number_of_sub_elements_already_counted(css_or_xpath)
    #   @css_or_xpath_that_has_been_counted[css_or_xpath] || 0
    # end

    # def short_type
    #   :book
    # end

  end
end
