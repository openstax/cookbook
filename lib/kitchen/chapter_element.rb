module Kitchen
  class ChapterElement < Element

    COUNTER_NAME = :chapter

    def self.short_type
      :chapter
    end

    def initialize(node:, document: nil)
      super(node: node, document: document, short_type: self.class.short_type)
    end

    def introduction_page
      pages('.introduction').first
    end

    # def title_header_number
    #   unit.nil? ? 1 : 2
    # end

    # def title
    #   first!("h#{title_header_number}[data-type='document-title']")
    # end

    def number_it
      title.prepend child: document.number_html(counter_names)
    end

    def counter_names
      [unit&.counter_names, COUNTER_NAME].flatten.compact
    end

    def glossaries
      search("div[data-type='glossary']")
    end

    def key_equations
      search("section.key-equations")
    end

    protected

    def as_enumerator
      ChapterElementEnumerator.new {|block| block.yield(self)}
    end

  end
end
