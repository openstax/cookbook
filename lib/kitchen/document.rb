# frozen_string_literal: true

require 'forwardable'

module Kitchen
  # Wrapper around a Nokogiri `Document`, adding search with Kitchen enumerators,
  # clipboards, pantries, etc.
  #
  class Document
    extend Forwardable

    # @return [Element] the current element yielded from search results
    attr_accessor :location
    # @return [Config] the configuration used in this document
    attr_reader :config
    # @return [IdTracker] the counter for duplicate IDs
    attr_reader :id_tracker

    # @!method selectors
    #   The document's selectors
    #   @see Config#selectors
    #   @return [Selectors::Base]
    def_delegators :config, :selectors

    # @!method to_xhtml
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#to_xhtml-instance_method Nokogiri::XML::Node#to_xhtml
    #   @return [String] the document as an XHTML string
    # @!method to_s
    #   Turn this node in to a string. If the document is HTML, this method returns html.
    #   If the document is XML, this method returns XML.
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#to_s-instance_method Nokogiri::XML::Node#to_s
    #   @return [String]
    # @!method to_xml
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#to_xml-instance_method Nokogiri::XML::Node#to_xml
    #   @return [String] the document as an XML string
    # @!method to_html
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#to_html-instance_method Nokogiri::XML::Node#to_html
    #   @return [String] the document as an HTML string
    # @!method encoding
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Document#encoding-instance_method Nokogiri::XML::Document#encoding
    #   @return [String] the document as an HTML string
    def_delegators :@nokogiri_document, :to_xhtml, :to_s, :to_xml, :to_html, :encoding

    # Return a new instance of Document
    #
    # @param nokogiri_document [Nokogiri::XML::Document]
    # @param config [Config]
    def initialize(nokogiri_document:, config: nil)
      @nokogiri_document = nokogiri_document
      @location = nil
      @config = config || Config.new
      @id_tracker = IdTracker.new

      # Nokogiri by default only recognizes the namespaces on the root node.  Add all others.
      raw&.add_all_namespaces! if @config.enable_all_namespaces
    end

    # Returns an enumerator that iterates over all children of this document
    # that match the provided selector or XPath arguments.  Updates `location`
    # during iteration.
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @return [ElementEnumerator]
    #
    def search(*selector_or_xpath_args)
      selector_or_xpath_args = [selector_or_xpath_args].flatten

      ElementEnumerator.new do |block|
        nokogiri_document.search(*selector_or_xpath_args).each do |inner_node|
          element = Kitchen::Element.new(
            node: inner_node,
            document: self,
            short_type: Utils.search_path_to_type(selector_or_xpath_args)
          )
          self.location = element
          block.yield(element)
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
    # TODO don't know if we need this
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
        document: self,
        short_type: "created_element_#{SecureRandom.hex(4)}"
      )
    end

    # Create a new Element from a string
    #
    # @param string [String] the element as a string
    #
    # @example
    #   create_element_from_string("<div class='foo'>bar</div>") #=> <div class="foo">bar</div>
    #
    # @return [Element]
    #
    def create_element_from_string(string)
      children = Nokogiri::XML("<foo>#{string}</foo>").search('foo').first.element_children
      raise('new_element must only make one top-level element') if children.many?

      node = children.first

      create_element(node.name, node.attributes).tap do |element|
        element.inner_html = node.children
      end
    end

    # Returns the underlying Nokogiri Document object
    #
    # @return [Nokogiri::XML::Document]
    #
    def raw
      @nokogiri_document
    end

    # Returns the locale for this document, default to `:en` if no locale detected
    #
    # @return [Symbol]
    #
    def locale
      raw.root['lang']&.to_sym || begin
        warn 'No `lang` attribute on this document so cannot detect its locale; defaulting to `:en`'
        :en
      end
    end

    protected

    attr_reader :nokogiri_document

  end
end
