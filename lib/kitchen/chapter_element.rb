module Kitchen
  class ChapterElement < Element

    attr_reader :unit

    COUNTER_NAME = :chapter

    def initialize(element:, unit: nil)
      @unit = unit
      super(node: element.raw, document: element.document)
    end

    def each_page
      # can we make each_chapter a mixin to both this class and UnitElement?
      raise(Kitchen::RecipeError, "An `each_page` command must be given a block") if !block_given?

      document.counter(PageElement::COUNTER_NAME).reset

      each("div[data-type='page']") do |element|
        page = PageElement.new(element: element, chapter: self)
        document.counter(PageElement::COUNTER_NAME).increment
        yield page
      end
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
