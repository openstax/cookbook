# frozen_string_literal: true

require 'forwardable'
require 'securerandom'

# rubocop:disable Metrics/ClassLength
module Kitchen
  # Abstract base class for all elements.  If you are looking for a simple concrete
  # element class, use `Element`.
  #
  class ElementBase
    extend Forwardable
    include Mixins::BlockErrorIf

    # The element's document
    # @return [Document]
    attr_reader :document

    # The element's type, e.g. +:page+
    # @return [Symbol, String]
    attr_reader :short_type

    # The enumerator class for this element
    # @return [Class]
    attr_reader :enumerator_class

    # The search query that located this element in the DOM
    # @return [SearchQuery]
    attr_accessor :search_query_that_found_me

    # @!method name
    #   Get the element name (the tag)
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#name-instance_method Nokogiri::XML::Node#name
    #   @return [String]
    # @!method name=
    #   Set the element name (the tag)
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#name=-instance_method Nokogiri::XML::Node#name=
    # @!method []
    #   Get an element attribute
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#[]-instance_method Nokogiri::XML::Node#[]
    #   @return [String]
    # @!method []=
    #   Set an element attribute
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#[]=-instance_method Nokogiri::XML::Node#[]=
    # @!method add_class
    #   Add a class to the element
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#add_class-instance_method Nokogiri::XML::Node#add_class
    # @!method remove_class
    #   Remove a class from the element
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#remove_class-instance_method Nokogiri::XML::Node#remove_class
    # @!method text
    #   Get the element text
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#text-instance_method Nokogiri::XML::Node#text
    #   @return [String]
    # @!method wrap
    #   Add HTML around this element
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#wrap-instance_method Nokogiri::XML::Node#wrap
    #   @return [Nokogiri::XML::Node]
    # @!method children
    #   Get the element's children
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#children-instance_method Nokogiri::XML::Node#children
    #   @return [Nokogiri::XML::NodeSet]
    # @!method to_html
    #   Get the element as HTML
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#to_html-instance_method Nokogiri::XML::Node#to_html
    #   @return [String]
    # @!method remove_attribute
    #   Removes an attribute from the element
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#remove_attribute-instance_method Nokogiri::XML::Node#remove_attribute
    # @!method classes
    #   Gets the element's classes
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#classes-instance_method Nokogiri::XML::Node#classes
    #   @return [Array<String>]
    # @!method path
    #   Get the path for this element
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#path-instance_method Nokogiri::XML::Node#path
    #   @return [String]
    # @!method inner_html=
    #   Set the inner HTML for this element
    #   @see https://www.rubydoc.info/github/sparklemotion/nokogiri/Nokogiri/XML/Node#inner_html=-instance_method Nokogiri::XML::Node#inner_html=
    #   @return Object
    def_delegators :@node, :name=, :name, :[], :[]=, :add_class, :remove_class,
                   :text, :wrap, :children, :to_html, :remove_attribute,
                   :classes, :path, :inner_html=

    # @!method config
    #   Get the config for this element's document
    #   @return [Config]
    def_delegators :document, :config

    # @!method selectors
    #   Get the selectors for this element's document
    #   @return [Selectors::Base]
    def_delegators :config, :selectors

    # @!method pantry
    #   Access the pantry for this element's document
    #   @return [Pantry]
    # @!method :clipboard
    #   Access the clipboard for this element's document
    #   @return [Clipboard]
    def_delegators :document, :pantry, :clipboard

    # Creates a new instance
    #
    # @param node [Nokogiri::XML::Node] the wrapped element
    # @param document [Document] the element's document
    # @param enumerator_class [ElementEnumeratorBase] the enumerator that matches this element type
    # @param short_type [Symbol, String] the type of this element
    #
    def initialize(node:, document:, enumerator_class:, short_type: nil)
      raise(ArgumentError, 'node cannot be nil') if node.nil?

      @node = node

      raise(ArgumentError, 'enumerator_class cannot be nil') if enumerator_class.nil?

      @enumerator_class = enumerator_class

      @short_type = short_type ||
                    self.class.try(:short_type) ||
                    "unknown_type_#{SecureRandom.hex(4)}"

      @document =
        case document
        when Kitchen::Document
          document
        else
          raise(ArgumentError, '`document` is not a known document type')
        end

      @ancestors = HashWithIndifferentAccess.new
      @search_query_matches_that_have_been_counted = {}
      @is_a_clone = false
    end

    # Returns ElementBase descendent type or nil if none found
    #
    # @param type [Symbol] the descendant type, e.g. `:page`
    # @return [Class] the child class for the given type
    #
    def self.descendant(type)
      @types_to_descendants ||=
        descendants.each_with_object({}) do |descendant, hash|
          next unless descendant.try(:short_type)

          hash[descendant.short_type] = descendant
        end

      @types_to_descendants[type]
    end

    # Returns ElementBase descendent type or Error if none found
    #
    # @param type [Symbol] the descendant type, e.g. `:page`
    # @raise if the type is unknown
    # @return [Class] the child class for the given type
    #
    def self.descendant!(type)
      descendant(type) || raise("Unknown ElementBase descendant type '#{type}'")
    end

    # Returns true if this element is the given type
    #
    # @param type [Symbol] the descendant type, e.g. `:page`
    # @raise if the type is unknown
    # @return [Boolean]
    #
    def is?(type)
      ElementBase.descendant!(type).is_the_element_class_for?(raw, config: config)
    end

    # Returns true if this class represents the element for the given node
    #
    # @param node [Nokogiri::XML::Node] the underlying node
    # @param config [Kitchen::Config]
    # @return [Boolean]
    #
    def self.is_the_element_class_for?(node, config:)
      Selector.named(short_type).matches?(node, config: config)
    end

    # Returns true if this element has the given class
    #
    # @param klass [String] the class to test for
    # @return [Boolean]
    #
    def has_class?(klass)
      (self[:class] || '').include?(klass)
    end

    # Returns the element's ID
    #
    # @return [String]
    #
    def id
      self[:id]
    end

    # Sets the element's ID
    #
    # @param value [String] the new value for the ID
    #
    def id=(value)
      self[:id] = value
    end

    # A way to set values and chain them
    #
    # @param property [String, Symbol] the name of the property to set
    # @param value [String] the value to set
    #
    # @example
    #   element.set(:name,"div").set("id","foo")
    #
    def set(property, value)
      case property.to_sym
      when :name
        self.name = value
      else
        self[property.to_sym] = value
      end
      self
    end

    # Returns this element's ancestor of the given type
    #
    # @param type [String, Symbol] e.g. +:page+, +:term+
    # @return [Ancestor]
    # @raise [StandardError] if there is no ancestor of the given type
    #
    def ancestor(type)
      @ancestors[type.to_sym]&.element || raise("No ancestor of type '#{type}'")
    end

    # Returns true iff this element has an ancestor of the given type
    #
    # @param type [String, Symbol] e.g. +:page+, +:term+
    # @return [Boolean]
    #
    def has_ancestor?(type)
      @ancestors[type.to_sym].present?
    end

    # Returns the element's ancestors
    #
    # @return [Array<Ancestor>]
    #
    attr_reader :ancestors

    # Adds ancestors to this element, for each incrementing descendant counts for this type
    #
    # @param args [Array<Hash, Ancestor, Element, Document>] the ancestors
    # @raise [StandardError] if there is already an ancestor with the one of
    #   the given ancestors' types
    #
    def add_ancestors(*args)
      args.each do |arg|
        case arg
        when Hash
          add_ancestors(*arg.values)
        when Ancestor
          add_ancestor(arg)
        when Element, Document
          add_ancestor(Ancestor.new(arg))
        else
          raise "Unsupported ancestor type `#{arg.class}`"
        end
      end
    end

    # Adds one ancestor, incrementing its descendant counts for this element type
    #
    # @param ancestor [Ancestor]
    # @raise [StandardError] if there is already an ancestor with the given ancestor's type
    #
    def add_ancestor(ancestor)
      if @ancestors[ancestor.type].present?
        raise "Trying to add an ancestor of type '#{ancestor.type}' but one of that " \
              "type is already present"
      end

      ancestor.increment_descendant_count(short_type)
      @ancestors[ancestor.type] = ancestor
    end

    # Return the elements in all of the ancestors
    #
    # @return [Array<ElementBase>]
    #
    def ancestor_elements
      @ancestors.values.map(&:element)
    end

    # Returns the count of this element's type in the given ancestor type
    #
    # @param ancestor_type [String, Symbol]
    #
    def count_in(ancestor_type)
      @ancestors[ancestor_type]&.get_descendant_count(short_type) ||
        raise("No ancestor of type '#{ancestor_type}'")
    end

    # Track that a sub element found by the given query has been counted
    #
    # @param search_query [SearchQuery] the search query matching the counted element
    # @param type [String] the type of the sub element that was counted
    #
    def remember_that_a_sub_element_was_counted(search_query, type)
      @search_query_matches_that_have_been_counted[search_query.to_s] ||= Hash.new(0)
      @search_query_matches_that_have_been_counted[search_query.to_s][type] += 1
    end

    # Undo the counts from a prior search query (so that they can be counted again)
    #
    # @param search_query [SearchQuery] the prior search query whose counts need to be undone
    #
    def uncount(search_query)
      @search_query_matches_that_have_been_counted.delete(search_query.to_s)&.each do |type, count|
        ancestors.each_value do |ancestor|
          ancestor.decrement_descendant_count(type, by: count)
        end
      end
    end

    # Returns the search history that found this element
    #
    # @return [SearchHistory]
    #
    def search_history
      SearchHistory.new(
        ancestor_elements.last&.search_history || SearchHistory.empty,
        search_query_that_found_me
      )
    end

    # Returns an ElementEnumerator that iterates over the provided selector or xpath queries
    #
    # @param selector_or_xpath_args [Array<String>] Selector or XPath queries
    # @param only [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will only be included in the
    #   search results if the method or callable returns true
    # @param except [Symbol, Callable] the name of a method to call on an element or a
    #   lambda or proc that accepts an element; elements will not be included in the
    #   search results if the method or callable returns false
    # @return [ElementEnumerator]
    #
    def search(*selector_or_xpath_args, only: nil, except: nil)
      block_error_if(block_given?)

      ElementEnumerator.factory.build_within(
        self,
        search_query: SearchQuery.new(
          css_or_xpath: selector_or_xpath_args,
          only: only,
          except: except
        )
      )
    end

    # Yields and returns the first child element that matches the provided
    # selector or XPath arguments.
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @yieldparam [Element] the matched XML element
    # @return [Element, nil] the matched XML element or nil if no match found
    #
    def first(*selector_or_xpath_args, reload: false)
      cached_search(selector_or_xpath_args, method: :first, reload: reload).tap do |element|
        yield(element) if block_given?
      end
    end

    # Yields and returns the first child element that matches the provided
    # selector or XPath arguments.
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @yieldparam [Element] the matched XML element
    # @raise [ElementNotFoundError] if no matching element is found
    # @return [Element] the matched XML element
    #
    def first!(*selector_or_xpath_args, reload: false)
      cached_search(selector_or_xpath_args, method: :first!, reload: reload).tap do |element|
        yield(element) if block_given?
      end
    end

    # @!method at
    #   @see first
    alias_method :at, :first

    # Returns an enumerator over the direct child elements of this element, with the
    # specific type (e.g. +TermElement+) if such type is available.
    #
    # @return [TypeCastingElementEnumerator]
    #
    def element_children
      block_error_if(block_given?)
      TypeCastingElementEnumerator.factory.build_within(
        self,
        search_query: SearchQuery.new(css_or_xpath: './*')
      )
    end

    # Searches for elements handled by a list of enumerator classes.  All element that
    # matches one of those enumerator classes are iterated over.
    #
    # @param enumerator_classes [Array<ElementEnumeratorBase>]
    # @return [TypeCastingElementEnumerator]
    #
    def search_with(*enumerator_classes)
      block_error_if(block_given?)
      raise 'must supply at least one enumerator class' if enumerator_classes.empty?

      factory = enumerator_classes[0].factory
      enumerator_classes[1..-1].each do |enumerator_class|
        factory = factory.or_with(enumerator_class.factory)
      end
      factory.build_within(self)
    end

    # Removes the element from its parent and places it on the specified clipboard
    #
    # @param to [Symbol, String, Clipboard, nil] the name of the clipboard (or a Clipboard
    #   object) to cut to. String values are converted to symbols. If not provided, the
    #   element is not placed on a clipboard.
    # @return [Element] the cut element
    #
    def cut(to: nil)
      block_error_if(block_given?)

      node.remove
      get_clipboard(to).add(self) if to.present?
      self
    end

    # Makes a copy of the element and places it on the specified clipboard.
    #
    # @param to [Symbol, String, Clipboard, nil] the name of the clipboard (or a Clipboard
    #   object) to cut to.  String values are converted to symbols.  If not provided, the
    #   copy is not placed on a clipboard.
    # @return [Element] the copied element
    #
    def copy(to: nil)
      # See `clone` method for a note about namespaces
      block_error_if(block_given?)

      the_copy = clone
      the_copy.raw.traverse do |node|
        next if node.text? || node.document?

        document.record_id_copied(node[:id])
      end
      get_clipboard(to).add(the_copy) if to.present?
      the_copy
    end

    # When an element is cut or copied, use this method to get the element's content;
    # keeps IDs unique
    def paste
      # See `clone` method for a note about namespaces
      block_error_if(block_given?)

      temp_copy = clone
      temp_copy.raw.traverse do |node|
        next if node.text? || node.document?

        node[:id] = document.modified_id_to_paste(node[:id]) unless node[:id].blank?
      end
      temp_copy.to_s
    end

    # Copy the element's id
    def copied_id
      document.record_id_copied(id)
      document.modified_id_to_paste(id)
    end

    # Delete the element
    #
    def trash
      node.remove
      self
    end

    def parent
      Element.new(node: raw.parent, document: document, short_type: "parent(#{short_type})")
    end

    # TODO: make it clear if all of these methods take Element, Node, or String

    # If child argument given, prepends it before the element's current children.
    # If sibling is given, prepends it as a sibling to this element.
    #
    # @param child [String] the child to prepend
    # @param sibling [String] the sibling to prepend
    # @raise [RecipeError] if specify other than just a child or a sibling
    #
    def prepend(child: nil, sibling: nil)
      require_one_of_child_or_sibling(child, sibling)

      if child
        if node.children.empty?
          node.children = child.to_s
        else
          node.children.first.add_previous_sibling(child)
        end
      else
        node.add_previous_sibling(sibling)
      end

      self
    end

    # If child argument given, appends it after the element's current children.
    # If sibling is given, appends it as a sibling to this element.
    #
    # @param child [String] the child to append
    # @param sibling [String] the sibling to append
    # @raise [RecipeError] if specify other than just a child or a sibling
    #
    def append(child: nil, sibling: nil)
      require_one_of_child_or_sibling(child, sibling)

      if child
        if node.children.empty?
          node.children = child.to_s
        else
          node.add_child(child)
        end
      else
        node.next = sibling
      end

      self
    end

    # Replaces this element's children
    #
    # @param with [String] the children to substitute for the current children
    #
    def replace_children(with:)
      node.children = with
      self
    end

    # Wraps the element's children in a new element.  Yields the new wrapper element
    # to a block, if provided.
    #
    # @param name [String] the wrapper's tag name, defaults to 'div'.
    # @param attributes [Hash] the wrapper's attributes.  XML attributes often use hyphens
    #   (e.g. 'data-type') which are hard to put into symbols.  Therefore underscores in
    #   keys passed to this method will be converted to hyphens.  If you really want an
    #   underscore you can use a double underscore.
    # @yieldparam [Element] the wrapper Element
    # @return [Element] self
    #
    def wrap_children(name='div', attributes={})
      if name.is_a?(Hash)
        attributes = name
        name = 'div'
      end

      node.children = node.document.create_element(name) do |new_node|
        # For some reason passing attributes to create_element doesn't work, so doing here
        attributes.each do |k, v|
          new_node[k.to_s.gsub(/([^_])_([^_])/, '\1-\2').gsub('__', '_')] = v
        end
        new_node.children = children.to_s
        yield Element.new(node: new_node, document: document, short_type: nil) if block_given?
      end.to_s

      self
    end

    # TODO: methods like replace_children that take string, either forbid or handle Element/Node args

    # Get the content of children matching the provided selector.  Mostly
    # useful when there is one child with text you want to extract.
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @return [String]
    #
    def content(*selector_or_xpath_args)
      node.search(*selector_or_xpath_args).children.to_s
    end

    # Returns true if this element has a child matching the provided selector
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @return [Boolean]
    #
    def contains?(*selector_or_xpath_args)
      !node.at(*selector_or_xpath_args).nil?
    end

    # Returns the header tag name that is one level under the first header tag in this
    # element, e.g. if this element is a "div" whose first header is "h1", this will
    # return "h2"
    #
    # TODO this method may not be needed.
    #
    # @return [String] the sub header tag name
    #
    def sub_header_name
      first_header = node.search('h1, h2, h3, h4, h5, h6').first

      if first_header.nil?
        'h1'
      else
        first_header.name.gsub(/\d/) { |num| (num.to_i + 1).to_s }
      end
    end

    # Mark the location so that if there's an error we can show the developer where.
    #
    def mark_as_current_location!
      document.location = self
    end

    # Returns the underlying Nokogiri object
    #
    # @return [Nokogiri::XML::Node]
    #
    def raw
      node
    end

    # Returns a string version of this element
    #
    # @return [String]
    #
    def inspect
      to_s
    end

    # Returns a string version of this element
    #
    # @return [String]
    #
    def to_s
      remove_default_namespaces_if_clone(node.to_s)
    end

    # Returns a string version of this element as XML
    #
    # @return [String]
    #
    def to_xml
      remove_default_namespaces_if_clone(node.to_xml)
    end

    # Returns a string version of this element as XHTML
    #
    # @return [String]
    #
    def to_xhtml
      remove_default_namespaces_if_clone(node.to_xhtml)
    end

    # Returns a clone of this object
    #
    def clone
      super.tap do |element|
        # When we call dup, the dup gets a bunch of default namespace stuff that
        # the original doesn't have.  Why? Unclear, but hard to get rid of nicely.
        # So here we mark that the element is a clone and then all of the `to_s`-like
        # methods gsub out the default namespace gunk.  Clones are mostly used for
        # clipboards and are accessed using `paste` methods, so modifying the `to_s`
        # behavior works for us.  If we end up using `clone` in a way that doesn't
        # eventually get converted to string, we may have to investigate other
        # options.
        #
        # An alternative is to remove the `xmlns` attribute in the `html` tag before
        # the input file is parse into a Nokogiri document and then to add it back
        # in when the baked file is written out.
        #
        # Nokogiri::XML::Document.remove_namespaces! is not an option because that blows
        # away our MathML namespace.
        #
        # I may not fully understand why the extra default namespace stuff is happening
        # FWIW :-)
        #
        element.node = node.dup
        element.is_a_clone = true
      end
    end

    def last_element
      node.last_element_child
    end

    # @!method pages
    #   Returns a pages enumerator
    def_delegators :as_enumerator, :pages, :chapters, :terms, :figures, :notes, :tables, :examples,
                   :metadatas, :non_introduction_pages, :units, :titles, :exercises, :references,
                   :composite_pages

    # Returns this element as an enumerator (over only one element, itself)
    #
    # @return [ElementEnumeratorBase] (actually returns the appropriate enumerator class for this element)
    #
    def as_enumerator
      enumerator_class.new(search_query: search_query_that_found_me) { |block| block.yield(self) }
    end

    protected

    # The wrapped Nokogiri node
    # @return [Nokogiri::XML::Node] the node
    attr_accessor :node

    # If this element is a clone
    # @return [Boolean]
    attr_accessor :is_a_clone

    # Return a clipboard
    #
    # @param name_or_object [String, Clipboard] the name of the clipboard or the clipboard itself
    # @return [Clipboard]
    #
    def get_clipboard(name_or_object)
      case name_or_object
      when Symbol
        clipboard(name: name_or_object)
      when Clipboard
        name_or_object
      else
        raise ArgumentError, "The provided argument (#{name_or_object}) is not " \
                             "a clipboard name or a clipboard"
      end
    end

    # Clean up some default namespace junk for cloned elements
    #
    # @param string [String] the string to clean
    def remove_default_namespaces_if_clone(string)
      if is_a_clone
        string.gsub('xmlns:default="http://www.w3.org/1999/xhtml"', '')
              .gsub('xmlns="http://www.w3.org/1999/xhtml"', '')
              .gsub('default:', '')
      else
        string
      end
    end

    def require_one_of_child_or_sibling(child, sibling)
      raise RecipeError, 'Only one of `child` or `sibling` can be specified' if child && sibling
      raise RecipeError, 'One of `child` or `sibling` must be specified' if !child && !sibling
    end

    def cached_search(*selector_or_xpath_args, method:, reload: false)
      key = [method, selector_or_xpath_args]
      @search_cache ||= {}
      @search_cache[key] = nil if reload
      # cache nil search results with a fake -1 value
      @search_cache[key] ||= search(*selector_or_xpath_args).send(method.to_sym) || -1
      @search_cache[key] == -1 ? nil : @search_cache[key]
    end

  end
end
# rubocop:enable Metrics/ClassLength
