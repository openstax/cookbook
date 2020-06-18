module Kitchen
  class TermElement < Element

    attr_reader :page

    def initialize(element:, page:)
      @page = page
      super(node: element.raw, document: element.document)
    end

  end
end
