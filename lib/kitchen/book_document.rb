module Kitchen
  class BookDocument < Document

    attr_reader :short_name

    # TODO store default selectors here and provide a method for overriding them
    # wonder if we should just write it out so YARD works
    # ACTUALLY make a Selectors class that has all of these defined, with defaults
    # and pass a (modified) instance into this class

    DEFAULT_SELECTORS = {
      page_title_selector: "*[data-type='document-title'][2]"
    }

    DEFAULT_SELECTORS.each do |name, value|
      attr_writer name

      define_method(name) do
        eval(%Q(@#{name} ||= "#{value}"))
      end
    end

    def initialize(document:, short_name: :not_set, numbering_style: "1.1.1")
      @numbering_style = numbering_style # not used yet
      @short_name = short_name

      super(nokogiri_document: document.is_a?(Document) ? document.raw : document)
    end

    def book
      BookElement.new(node: nokogiri_document.search("html").first, document: self)
    end

  end
end
