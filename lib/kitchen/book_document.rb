module Kitchen
  class BookDocument < Document

    attr_reader :short_name

    def initialize(document:, short_name: :not_set, config: nil)
      @short_name = short_name

      super(nokogiri_document: document.is_a?(Document) ? document.raw : document,
            config: config)
    end

    def book
      BookElement.new(node: nokogiri_document.search("html").first, document: self)
    end

  end
end
