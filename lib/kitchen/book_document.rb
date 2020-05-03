module Kitchen
  class BookDocument < Document

    def initialize(document:, numbering_style: "1.1.1")
      @numbering_style = numbering_style # not used yet

      super(nokogiri_document: document.is_a?(Document) ? document.raw : document)
    end

    # Iterates over all children in the book.  Also increments a `:chapter` counter,
    # resetting it at the start of the iteration.
    #
    # @yieldparam [Element] the matched XML element
    #
    def each_chapter

      # can we make each_chapter a mixin to both this class and UnitElement?
      raise(Kitchen::RecipeError, "An `each_chapter` command must be given a block") if !block_given?

      counter(ChapterElement::COUNTER_NAME).reset

      each("div[data-type='chapter']") do |element|
        chapter = ChapterElement.new(element: element)
        counter(ChapterElement::COUNTER_NAME).increment
        yield chapter
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

  end
end
