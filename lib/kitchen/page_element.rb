module Kitchen
  class PageElement < Element

    attr_reader :chapter

    COUNTER_NAME = :page

    def initialize(element:, chapter:)
      @chapter = chapter
      super(node: element.raw, document: element.document)
    end

    def title
      first!("h#{chapter.title_header_number + 1}[data-type='document-title']")
    end

    def number_it
      title.prepend child: document.number_html(counter_names)
    end

    def counter_names
      [chapter.counter_names, COUNTER_NAME].flatten.compact
    end


  end
end
