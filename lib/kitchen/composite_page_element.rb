module Kitchen
  class CompositePageElement < ElementBase

    def initialize(node:, document: nil)
      super(node: node,
            document: document,
            enumerator_class: CompositePageElementEnumerator,
            short_type: :composite_page)
    end

    def title
      # Get the title in the immediate children, not the one in the metadata.  Could use
      # CSS of ":not([data-type='metadata']) > [data-type='document-title'], [data-type='document-title']"
      # but xpath is shorter
      first!("./*[@data-type = 'document-title']")
    end

    def self.is_the_element_class_for?(node)
      node['data-type'] == "composite-page"
    end

    def is_index?
      has_class?("os-index-container")
    end

  end
end
