module Kitchen
  class TermElement < Element

    attr_accessor :page, :chapter, :unit, :book

    def self.short_type
      :term
    end

    def initialize(element:)
      # @page = page
      super(node: element.raw, document: element.document, short_type: :term)
    end

  end
end
