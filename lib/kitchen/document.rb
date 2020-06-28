module Kitchen
  class Document

    attr_accessor :location

    def initialize(nokogiri_document:)
      @nokogiri_document = nokogiri_document
      @location = nil
    end

    # Returns an enumerator that iterates over all children of this document
    # that match the provided selector or XPath arguments.
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @return [ElementEnumerator]
    #
    def search(*selector_or_xpath_args)
      selector_or_xpath_args = [selector_or_xpath_args].flatten

      ElementEnumerator.new do |block|
        nokogiri_document.search(*selector_or_xpath_args).each do |inner_node|
          Kitchen::Element.new(node: inner_node, document: self).tap do |element|
            self.location = element
            block.yield(element)
          end
        end
      end
    end

    # Returns the document's clipboard with the given name.
    #
    # @param name [Symbol, String] the name of the clipboard.  String values are
    #   converted to symbols.
    # @return [Clipboard]
    #
    def clipboard(name: :default)
      (@clipboards ||= {})[name.to_sym] ||= Clipboard.new
    end

    # Returns the document's pantry with the given name.
    #
    # @param name [Symbol, String] the name of the pantry.  String values are
    #   converted to symbols.
    # @return [Pantry]
    #
    def pantry(name: :default)
      (@pantries ||= {})[name.to_sym] ||= Pantry.new
    end

    # Returns the document's counter with the given name.
    #
    # @param name [Symbol, String] the name of the counter.  String values are
    #   converted to symbols.
    # @return [Counter]
    #
    def counter(name)
      (@counters ||= {})[name.to_sym] ||= Counter.new
    end

    # Create a new Element
    #
    # @param name [String] the tag name
    # @param args [Array<String, Hash>]
    #
    # @example div with a class
    #   create_element("div", class: "foo") #=> <div class="foo"></div>
    # @example div with some content and a class
    #   cretae_element("div", "contents", class: "foo") #=> <div class="foo">contents</div>
    # @example div created by block
    #   create_element("div") {|elem| elem['class'] = 'foo'} #=> <div class="foo"></div>
    #
    # @return [Element]
    #
    def create_element(name, *args, &block)
      Kitchen::Element.new(
        node: @nokogiri_document.create_element(name, *args, &block),
        document: self
      )
    end

    # Returns the underlying Nokogiri Document object
    #
    # @return [Nokogiri::XML::Document]
    def raw
      @nokogiri_document
    end

    protected

    attr_reader :nokogiri_document

  end
end
