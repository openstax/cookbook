module Kitchen
  class PageElement < Element

    COUNTER_NAME = :page

    def self.short_type
      :page
    end

    # TODO maybe can just be "type" instead of "short_type"

    def initialize(element:)
      super(node: element.raw, document: element.document, short_type: :page)
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


    protected

    def as_enumerator
      PageElementEnumerator.new {|block| block.yield(self)}
    end

  end
end
