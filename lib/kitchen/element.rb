require 'forwardable'
require 'securerandom'

module Kitchen
  class Element
    extend Forwardable
    # include Enumerable

    attr_reader :document
    attr_reader :short_type

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
    def_delegators :@node, :name=, :name, :[], :[]=, :add_class, :remove_class, :text, :wrap, :children, :to_html

    def initialize(node:, number: nil, document:, short_type: nil)
      raise "node cannot be nil" if node.nil?
      @node = node
      @number = number
      @document = document
      @ancestors = HashWithIndifferentAccess.new
      @short_type = short_type || "unnamed_type_#{SecureRandom.hex(4)}"
      @counts_in = {}
    end

    def has_class?(klass)
      (self[:class] || "").include?(klass)
    end

    def number
      @number || raise("This element has no number because it wasn't created as part of a multi-element search")
    end

    def id
      self[:id]
    end

    def ancestor(type)
      @ancestors[type.to_sym]&.element_or_document || raise("No ancestor of type '#{type}'")
    end

    def ancestors
      @ancestors
    end

    # def set_ancestors(ancestors)
    #   # not copying contents, just getting our own hash
    #   @ancestors = HashWithIndifferentAccess.new(ancestors)
    # end

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
      @counts_in[ancestor.type] = ancestor.increment_descendant_count(short_type)
    end

    def count_in(ancestor_type)
      @counts_in[ancestor_type] || raise("No ancestor of type '#{ancestor_type}'")
    end

    # Iterates over all children of this element that match the provided
    # selector or XPath arguments.
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @yieldparam [Element] the matched XML element
    #
    def each(*selector_or_xpath_args)
      raise(Kitchen::RecipeError, "An `each` command must be given a block") if !block_given?

      node.search(*selector_or_xpath_args).each do |inner_node|
        Kitchen::Element.new(node: inner_node, document: document).tap do |element|
          document.location = element
          yield element
        end
      end
    end

    def elements(*selector_or_xpath_args)
      ElementEnumerator.new do |block|
        node.search(*selector_or_xpath_args).each.with_index do |inner_node, index|
          Kitchen::Element.new(node: inner_node, number: index+1, document: document).tap do |element|
            document.location = element
            block.yield(element)
          end
        end
      end
    end


    #   if block_given?
    #     each_enumerator
    #     node.search(*selector_or_xpath_args).each do |inner_node|
    #       Kitchen::Element.new(node: inner_node, document: document).tap do |element|
    #         document.location = element
    #         # yield element
    #         block.call(element)
    #       end
    #     end
    #   else
    #     to_enum(:each)
    #   end
    # end

    # def each_enumerator(*selector_or_xpath_args)
    #   Enumerator.new do |block|
    #     node.search(*selector_or_xpath_args).each do |inner_node|
    #       Kitchen::Element.new(node: inner_node, document: document).tap do |element|
    #         document.location = element
    #         block.yield(element)
    #       end
    #     end
    #   end
    # end

    # Yields and returns the first child element that matches the provided
    # selector or XPath arguments.
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @yieldparam [Element] the matched XML element
    # @return [Element, nil] the matched XML element or nil if no match found
    #
    def first(*selector_or_xpath_args)
      inner_node = node.search(*selector_or_xpath_args).first
      return nil if inner_node.nil?
      Kitchen::Element.new(node: inner_node, document: document).tap do |element|
        document.location = element
        yield element if block_given?
      end
    end

    alias_method :at, :first

    # Yields and returns the first child element that matches the provided
    # selector or XPath arguments.
    #
    # @param selector_or_xpath_args [Array<String>] CSS selectors or XPath arguments
    # @yieldparam [Element] the matched XML element
    # @raise [ElementNotFoundError] if no matching element is found
    # @return [Element] the matched XML element
    #
    def first!(*selector_or_xpath_args)
      first(*selector_or_xpath_args) { yield if block_given? } ||
        raise(Kitchen::ElementNotFoundError,
              "Could not find first element matching '#{selector_or_xpath_args}'")
    end

    # Removes the element from its parent and places it on the specified clipboard
    #
    # @param to [Symbol, String] the name of the clipboard to cut to. String values
    #   are converted to symbols.
    #
    def cut(to: :default)
      node.remove
      clipboard(to).add(node)
      self
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

    # Makes a copy of the element and places it on the specified clipboard; if a
    # block is given, runs the block on the copy.
    #
    # @param to [Symbol, String] the name of the clipboard to cut to.  String values
    #   are converted to symbols.
    #
    def copy(to: :default)
      the_copy = node.clone
      yield the_copy if block_given?
      clipboard(to).add(the_copy)
      self
    end

    # Delete the element
    #
    def trash
      node.remove
      self
    end

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

    protected

    attr_reader :node

  end
end
