require 'forwardable'
require 'securerandom'

module Kitchen
  class Element
    extend Forwardable

    attr_reader :document
    attr_reader :short_type

    def self.short_type
      :element
    end

    # @!method name
    #   Get the element name (the tag)
    # @!method name=
    #   Set the element name (the tag)
    # @!method []
    #   Get an element attribute
    # @!method []=
    #   Set an element attribute
    # @!method add_class
    #   Add a class to the element
    # @!method remove_class
    #   Remove a class from the element
    def_delegators :@node, :name=, :name, :[], :[]=, :add_class, :remove_class,
                           :text, :wrap, :children, :to_html, :remove_attribute,
                           :classes

    def initialize(node:, document:, short_type: nil)
      raise "node cannot be nil" if node.nil?
      @node = node
      @document =
        case document
        when Kitchen::Document
          document
        when Nokogiri::XML::Document
          Kitchen::Document.new(nokogiri_document: document)
        else
          raise(ArgumentError, "`document` is not a known document type")
        end

      @ancestors = HashWithIndifferentAccess.new
      @short_type = short_type || "unnamed_type_#{SecureRandom.hex(4)}"
      @counts_in = HashWithIndifferentAccess.new
      @css_or_xpath_that_has_been_counted = {}
    end

    def has_class?(klass)
      (self[:class] || "").include?(klass)
    end

    def id
      self[:id]
    end

    def id=(value)
      self[:id] = value
    end

    def ancestor(type)
      @ancestors[type.to_sym]&.element || raise("No ancestor of type '#{type}'")
    end

    def ancestors
      @ancestors
    end

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

    def add_ancestor(ancestor)
      # TODO freak out if already have an ancestor of this type
      @ancestors[ancestor.type] = ancestor
    end

    def count_as_descendant
      @ancestors.each_pair do |type, ancestor|
        @counts_in[type] = ancestor.increment_descendant_count(short_type)
      end
    end

    def count_in(ancestor_type)
      @counts_in[ancestor_type] || raise("No ancestor of type '#{ancestor_type}'")
    end

    def remember_that_sub_elements_are_already_counted(css_or_xpath:, count:)
      @css_or_xpath_that_has_been_counted[css_or_xpath] = count
    end

    def have_sub_elements_already_been_counted?(css_or_xpath)
      number_of_sub_elements_already_counted(css_or_xpath) != 0
    end

    def number_of_sub_elements_already_counted(css_or_xpath)
      @css_or_xpath_that_has_been_counted[css_or_xpath] || 0
    end


    # TODO get rid of this `.each` - make users say `.search(blah).each`
    # Iterates over all children of this element that match the provided
    # selector or XPath arguments.
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @yieldparam [Element] the matched XML element
    #
    def each(*selector_or_xpath_args)
      # selector_or_xpath_args = [selector_or_xpath_args].flatten

      raise(Kitchen::RecipeError, "An `each` command must be given a block") if !block_given?

      search(*selector_or_xpath_args).each{|element| yield element}

    end

    def search(*selector_or_xpath_args)
      # TODO error if block given?
      ElementEnumeratorFactory.within(
        new_enumerator_class: ElementEnumerator,
        element: self,
        css_or_xpath: nil,
        default_css_or_xpath: selector_or_xpath_args,
      )
    end

    # Yields and returns the first child element that matches the provided
    # selector or XPath arguments.
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @yieldparam [Element] the matched XML element
    # @return [Element, nil] the matched XML element or nil if no match found
    #
    def first(*selector_or_xpath_args)
      search(*selector_or_xpath_args).first.tap do |element|
        yield(element) if block_given?
      end
    end

    # TODO first and first! should record ancestry (make this a spec)

    # # Yields and returns the first child element that matches the provided
    # # selector or XPath arguments.
    # #
    # # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # # @yieldparam [Element] the matched XML element
    # # @raise [ElementNotFoundError] if no matching element is found
    # # @return [Element] the matched XML element
    # #
    def first!(*selector_or_xpath_args)
      search(*selector_or_xpath_args).first!.tap do |element|
        yield(element) if block_given?
      end
    end

    alias_method :at, :first

    # Removes the element from its parent and places it on the specified clipboard
    #
    # @param to [Symbol, String, Clipboard, nil] the name of the clipboard (or a Clipboard
    #   object) to cut to. String values are converted to symbols. If not provided, the
    #   element is not placed on a clipboard.
    # @return [Element] the cut element
    #
    def cut(to: nil)
      node.remove
      clipboard(to).add(self) if to.present?
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
      the_copy = clone
      clipboard(to).add(the_copy) if to.present?
      self
    end

    # Delete the element
    #
    def trash
      node.remove
      self
    end

    def parent
      self.class.new(node: raw.parent, document: document)
    end

    # TODO make it clear if all of these methods take Element, Node, or String

    # If child argument given, prepends it before the element's current children.
    # If sibling is given, prepends it as a sibling to this element.
    #
    # @param child [String] the child to prepend
    # @param sibling [String] the sibling to prepend
    #
    def prepend(child: nil, sibling: nil)
      if child && sibling
        raise RecipeError, "Only one of `child` or `sibling` can be specified"
      elsif !child && !sibling
        raise RecipeError, "One of `child` or `sibling` must be specified"
      elsif child
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
    #
    def append(child: nil, sibling: nil)
      if child && sibling
        raise RecipeError, "Only one of `child` or `sibling` can be specified"
      elsif !child && !sibling
        raise RecipeError, "One of `child` or `sibling` must be specified"
      elsif child
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

    # TODO methods like replace_children that take string, either forbid or handle Element/Node args

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
      # TODO search(*selector_or_xpath_args).any?
      !node.at(*selector_or_xpath_args).nil?
    end

    # Returns the header tag name that is one level under the first header tag in this
    # element, e.g. if this element is a "div" whose first header is "h1", this will
    # return "h2"
    #
    # @return [String] the sub header tag name
    #
    def sub_header_name
      first_header = node.search("h1, h2, h3, h4, h5, h6").first

      first_header.nil? ?
        "h1" :
        first_header.name.gsub(/\d/) {|num| (num.to_i + 1).to_s}
    end

    # Returns the underlying Nokogiri object
    #
    # @return [Nokogiri::XML::Node]
    #
    def raw
      node
    end

    def to_s
      node.to_s
    end

    # Convenience method for when an element is cut it can then be pasted like a clipboard is
    def paste
      to_s
    end

    def inspect
      to_s
    end

    # TODO implement in child classes
    def clone
      super.tap do |element|
        element.node = node.dup
      end
    end

    # @!method pages
    #   Returns a pages enumerator
    def_delegators :as_enumerator, :pages, :chapters, :terms, :figures, :notes, :tables, :examples

    protected

    attr_accessor :node

    def as_enumerator
      ElementEnumerator.new {|block| block.yield(self)}
    end

    def clipboard(name_or_object)
      case name_or_object
      when Symbol
        document.clipboard(name: name_or_object)
      when Clipboard
        name_or_object
      else
        raise ArgumentError, "The provided argument (#{name_or_object}) is not "
                             "a clipboard name or a clipboard"
      end
    end

    # TODO put this in a module that can be included here and in ElementEnumerator
    def block_error_if(block_given)
      calling_method = begin
        this_method_location_index = caller_locations.find_index do |location|
          location.label == "block_error_if"
        end

        caller_locations[(this_method_location_index || -1) + 1].label
      end

      raise(RecipeError, "The `#{calling_method}` method does not take a block argument") if block_given
    end

  end
end
