module Kitchen
  class PageElement < Element

    # TODO kill counter names?
    COUNTER_NAME = :page

    def self.short_type
      :page
    end

    # TODO maybe can just be "type" instead of "short_type"

    def initialize(node:, document: nil)
      super(node: node, document: document, short_type: self.class.short_type)
    end

    def title
      # first!("h#{chapter.title_header_number + 1}[data-type='document-title']")
      first!(document.page_title_selector)
    end

    def number_it
      title.prepend child: document.number_html(counter_names)
    end

    def counter_names
      [chapter&.counter_names, COUNTER_NAME].flatten.compact
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

    protected

    def as_enumerator
      PageElementEnumerator.new {|block| block.yield(self)}
    end

  end
end
