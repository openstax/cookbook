module Kitchen
  class ChapterElement < Element

    def self.short_type
      :chapter
    end

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: ChapterElementEnumerator,
            short_type: self.class.short_type)
    end

    def introduction_page
      pages('.introduction').first
    end

    def glossaries
      search("div[data-type='glossary']")
    end

    def key_equations
      search("section.key-equations")
    end

  end
end
