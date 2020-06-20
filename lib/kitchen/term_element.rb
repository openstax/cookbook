module Kitchen
  class TermElement < Element

    attr_accessor :page, :chapter, :unit, :book

    def initialize(element:)
      # @page = page
      super(node: element.raw, document: element.document, short_type: :term)
    end

  end
end
