# frozen_string_literal: true

module Kitchen
  # A specialized +Recipe+ that yields a +BookDocument+ instead of a plain
  # +Document+
  #
  class BookRecipe < Recipe

    # The book's short name
    #
    # @return [Symbol]
    #
    attr_reader :book_short_name

    # Make a new BookRecipe
    #
    # @param book_short_name [Symbol, String] the book's short name
    # @yieldparam doc [BookDocument] an object representing an XML document
    #
    def initialize(book_short_name: :not_set, &block)
      @book_short_name = book_short_name.to_sym
      super(&block)
    end

    # Overrides +document=+ to ensure a +BookDocument+ is stored
    #
    # @param document [Document, Nokogiri::XML::Document] the document
    #
    def document=(document)
      super(document)
      @document = Kitchen::BookDocument.new(
        document: @document,
        short_name: book_short_name,
        config: @document.config.clone
      )
    end

  end
end
