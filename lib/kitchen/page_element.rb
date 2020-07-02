module Kitchen
  class PageElement < ElementBase

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: PageElementEnumerator,
            short_type: :page)
    end

    def title
      # first!("h#{chapter.title_header_number + 1}[data-type='document-title']")
      first!(document.page_title_selector)
    end

    def terms
      TermElementEnumerator.within(element: self)
    end

    def is_introduction?
      has_class?("introduction")
    end

    def metadata
      first!("div[data-type='metadata']")
    end

    def summary
      first!("section.summary")
    end

    def exercises
      first!("section.exercises")
    end

    def exercises_section
      search("")
    end

  end
end
