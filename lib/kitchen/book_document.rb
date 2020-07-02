module Kitchen
  class BookDocument < Document

    attr_reader :short_name

    # TODO - An idea started to not have selectors in specific Element classes but
    # instead to provide them to the Document class when it was constructed.  This
    # came up because not all books may have the exact same structure and we may
    # need different selectors in those different cases.  Phil also brought up that
    # this information can be part of a tagging legend that we use for overall
    # validation on the document to be baked.  So everyone should put some thought
    # into how we can combine these strategies to give us flexibility in setting
    # selectors and reuse information required for validation efforts.
    #
    # All we have implemented here is an early attempt in this direction of keeping
    # the selectors available somewhere else that isn't the specific Element class,
    # but this isn't good enough.
    #
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
