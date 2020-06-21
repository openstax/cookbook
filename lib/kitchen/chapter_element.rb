module Kitchen
  class ChapterElement < Element

    attr_accessor :unit, :book

    COUNTER_NAME = :chapter

    def self.short_type
      :chapter
    end

    def initialize(element:, unit: nil)
      @unit = unit
      super(node: element.raw, document: element.document, short_type: :chapter)
    end

    def each_page
      # can we make each_chapter a mixin to both this class and UnitElement?
      raise(Kitchen::RecipeError, "An `each_page` command must be given a block") if !block_given?

      document.counter(PageElement::COUNTER_NAME).reset # TODO make this local to this instance (and do the with_count thing)

      each("div[data-type='page']") do |element|
        page = PageElement.new(element: element, chapter: self)
        document.counter(PageElement::COUNTER_NAME).increment
        yield page
      end
    end

    def each_page_with_count
      # can we make each_chapter a mixin to both this class and UnitElement?
      raise(Kitchen::RecipeError, "An `each_page` command must be given a block") if !block_given?

      document.counter(PageElement::COUNTER_NAME).reset # TODO make this local to this instance (and do the with_count thing)

      each("div[data-type='page']") do |element|
        page = PageElement.new(element: element, chapter: self)
        document.counter(PageElement::COUNTER_NAME).increment
        yield page, document.counter(PageElement::COUNTER_NAME).get
      end
    end

    def introduction_page
      element = first("div[data-type='page'].introduction")
      PageElement.new(element: element, chapter: self)
    end

    def each_figure_with_count
      # can we make each_chapter a mixin to both this class and UnitElement?
      raise(Kitchen::RecipeError, "An `each_figure` command must be given a block") if !block_given?

      document.counter(:chapter_figure).reset

      each("figure") do |element|
        figure = FigureElement.new(element: element, chapter: self)
        document.counter(:chapter_figure).increment
        yield figure, document.counter(:chapter_figure).get
      end

    end

    # def pages
    #   Enumerator.new do |block|
    #     each("div[data-type='page']") do |element|
    #       page = PageElement.new(element: element, chapter: self) # TODO store page on nokogiri element and reuse?
    #       block.yield(page)
    #     end
    #   end
    # end

    def pages
      PageElementEnumerator.within(element: self)
      # ChapterElementEnumerator.new([self], :each).pages
    end

    def title_header_number
      unit.nil? ? 1 : 2
    end

    def title
      first!("h#{title_header_number}[data-type='document-title']")
    end

    def number_it
      title.prepend child: document.number_html(counter_names)
    end

    def counter_names
      [unit&.counter_names, COUNTER_NAME].flatten.compact
    end

  end
end
