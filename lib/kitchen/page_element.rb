module Kitchen
  class PageElement < ElementBase

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: PageElementEnumerator,
            short_type: :page)
    end

    def title
      # Get the title that isn't in the metadata
      first!(":not([data-type='metadata']) > [data-type='document-title'], [data-type='document-title']")
    end

    def is_introduction?
      has_class?("introduction")
    end

    def is_preface?
      has_class?("preface")
    end

    def is_appendix?
      has_class?("appendix")
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

    def self.is_the_element_class_for?(node)
      node['data-type'] == "page"
    end

  end
end
