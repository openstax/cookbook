module Kitchen
  class BookRecipe < Recipe

    attr_reader :book_short_name

    # Make a new BookRecipe
    #
    # @yieldparam doc [Document] an object representing an XML document
    #
    def initialize(book_short_name: :not_set, &block)
      @book_short_name = book_short_name
      super(&block)
    end

    def document=(document)
      super(document)
      @document = Kitchen::BookDocument.new(
        document: @document,
        short_name: book_short_name,
        numbering_style: "1.1"
      )
    end

  end
end
