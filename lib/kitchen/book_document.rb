# frozen_string_literal: true
module Kitchen
  # A specialized form of +Document+ for our books.
  #
  class BookDocument < Document

    # This book's short name, used to look up translations, etc.
    # @return [Symbol] the name
    #
    attr_reader :short_name

    # Creates a new BookDocument
    #
    # @param document [Document, Nokogiri::XML::Document] the underlying document;
    #   if a +Document+ it is converted to a +Nokogiri::XML::Document+
    # @param short_name [Symbol, String] the book's short name
    # @param config [Config] the book's configuration
    #
    def initialize(document:, short_name: :not_set, config: nil)
      @short_name = short_name.to_sym

      super(nokogiri_document: document.is_a?(Document) ? document.raw : document,
            config: config)
    end

    # Returns the top-level +BookElement+ for this document
    #
    # @return [BookElement]
    #
    def book
      BookElement.new(node: nokogiri_document.search('html').first, document: self)
    end

  end
end
